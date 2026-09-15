#!/usr/bin/env bash
# Prepares a local test environment for the website (Jekyll via Bundler),
# following the steps in README.md. Target: Ubuntu / WSL2.
# Safe to re-run: steps that are already done are skipped.
set -euo pipefail

readonly apt_packages=(ruby-full build-essential zlib1g-dev)

say() { printf '\033[1;34mrdbweb\033[0m  %s\n' "$*" >&2; }
die() { printf 'rdbweb: %s\n' "$*" >&2; exit 1; }

case "${1:-}" in
  '') ;;
  -h|--help)
    cat <<'HELP'
Usage: ./install_test_env.sh

Installs the system packages Jekyll needs (sudo apt), Bundler in the version
recorded in Gemfile.lock (user gem directory, no sudo), the project's gems
into vendor/bundle, and then builds the site once to verify the environment.
HELP
    exit 0 ;;
  *) die "unknown argument: $1 (see --help)" ;;
esac

cd "$(dirname "$(readlink -f "$0")")"
[[ -f Gemfile.lock ]] || die 'Gemfile.lock not found next to the script'

missing=()
for pkg in "${apt_packages[@]}"; do
  dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q 'install ok installed' || missing+=("$pkg")
done
if ((${#missing[@]})); then
  say "installing system packages: ${missing[*]}"
  sudo apt-get update
  sudo apt-get install -y "${missing[@]}"
else
  say 'system packages already installed'
fi

bundler_version=$(awk '/^BUNDLED WITH/ { getline; gsub(/ /, ""); print }' Gemfile.lock)
[[ -n "$bundler_version" ]] || die 'Gemfile.lock has no BUNDLED WITH section'

gem_bin="$(ruby -e 'print Gem.user_dir')/bin"
gem_bin_on_path=0
case ":$PATH:" in *":$gem_bin:"*) gem_bin_on_path=1 ;; esac
export PATH="$gem_bin:$PATH"

if gem list -i bundler -v "$bundler_version" >/dev/null; then
  say "bundler $bundler_version already installed"
else
  say "installing bundler $bundler_version into the user gem directory"
  gem install --user-install --no-document bundler -v "$bundler_version"
fi

# .bundle/ is ignored by git, so a fresh clone lacks the vendor/bundle setting
bundle config set --local path vendor/bundle

say 'installing project gems into vendor/bundle'
bundle install

say 'verifying: building the site'
bundle exec jekyll build --quiet

say 'environment ready'
if ((!gem_bin_on_path)); then
  # skrypt biegnie w podpowloce, wiec PATH trzeba ustawic w terminalu uzytkownika
  say 'Bundler is not on your PATH. After this script finishes, run in this terminal:'
  say "  export PATH=\"$gem_bin:\$PATH\""
  say 'and add the same line to ~/.bashrc to keep it in new terminals'
fi
say 'start the dev server:  bundle exec jekyll serve --host 0.0.0.0'
