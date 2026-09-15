#!/usr/bin/env bash
set -euo pipefail

readonly repo='michalwidera/retractordb'
readonly api="https://api.github.com/repos/$repo/releases"
readonly names=(xretractor xqry xtrdb)
scope=''
prefix=''
version=''
command='install'
service_requested=0
unit_file='/etc/systemd/system/xretractor.service'
unit_marker='# Managed by retractordb.com/install.sh'

say() { printf '\033[1;34mRetractorDB\033[0m  %s\n' "$*" >&2; }
die() { printf 'RetractorDB: %s\n' "$*" >&2; exit 1; }
has_tty() { ( : > /dev/tty ) 2>/dev/null; }

usage() {
  cat <<'HELP'
Usage: bash install.sh [install|upgrade|uninstall|list|status] [options]
  --version VERSION   Install a published stable release (for example 0.1.10)
  --user              Install in ~/.local
  --system            Install in /usr/local (run as root)
  --prefix PATH       Use an absolute custom prefix
  --service           Install or retain a systemd service (system scope only)
  --help              Show this help

Debian packages and their systemd service are managed by the system package
manager. The installer manages only its own archive and optional service.
HELP
}

while (($#)); do
  case "$1" in
    install|upgrade|uninstall|list|status) command="$1"; shift ;;
    --user) scope='user'; shift ;;
    --system) scope='system'; shift ;;
    --service) service_requested=1; shift ;;
    --version|--prefix)
      (($# >= 2)) || die "$1 requires a value"
      if [[ $1 == --version ]]; then version="$2"; else prefix="$2"; fi
      shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

[[ -z $version || $version =~ ^v?[0-9]+\.[0-9]+\.[0-9]+$ ]] || die 'Version must be vMAJOR.MINOR.PATCH'
[[ $command == install || $command == upgrade || -z $version ]] || die '--version applies only to install or upgrade'
((service_requested == 0)) || [[ $command == install || $command == upgrade ]] || die '--service applies only to install or upgrade'
command -v curl >/dev/null || die 'curl is required'
command -v python3 >/dev/null || die 'python3 is required'
command -v sha256sum >/dev/null || die 'sha256sum is required'

case "$(uname -s):$(uname -m)" in
  Linux:x86_64|Linux:amd64) arch='x86_64'; machine=62 ;;
  Linux:aarch64|Linux:arm64) arch='aarch64'; machine=183 ;;
  *) die "No portable release for $(uname -s)/$(uname -m); supported: x86_64, aarch64" ;;
esac

user_prefix="${HOME:?}/.local"
system_prefix='/usr/local'
state_path() { printf '%s/lib/retractordb/installer-state' "$1"; }
has_state() { [[ -f $(state_path "$1") ]]; }

if [[ $command != list ]]; then
  if [[ -z $prefix ]]; then
    if [[ -z $scope ]]; then
      if has_state "$user_prefix" && has_state "$system_prefix"; then
        if has_tty; then
          printf 'Two managed installations found. Choose [u]ser or [s]ystem: ' > /dev/tty
          read -r answer < /dev/tty
          case "$answer" in u|U) scope='user' ;; s|S) scope='system' ;; *) die 'Choose --user or --system' ;; esac
        else
          die 'Two managed installations found; choose --user or --system'
        fi
      elif has_state "$user_prefix"; then scope='user'
      elif has_state "$system_prefix"; then scope='system'
      elif ((EUID == 0)); then scope='system'
      else scope='user'
      fi
    fi
    if [[ $scope == user ]]; then prefix="$user_prefix"; else prefix="$system_prefix"; fi
  fi
  if [[ $scope == system && $command != status ]] && ((EUID != 0)); then
    die 'System install needs root; run the command with sudo'
  fi
  if ((service_requested)) && ((EUID != 0)); then die '--service needs root'; fi
  if [[ $command == install ]]; then
    resolved=0
    for attempt in 1 2 3; do
      [[ $prefix == /* && $prefix != / && $prefix != /usr && $prefix != /bin ]] || die 'Prefix must be an absolute application install prefix'
      [[ $prefix != *'/../'* && $prefix != */.. && $prefix != *'/./'* ]] || die 'Prefix cannot contain . or .. components'
      prefix="${prefix%/}"
      [[ ! -e $prefix || -d $prefix ]] || die "Prefix exists and is not a directory: $prefix"
      conflict=''
      if ! has_state "$prefix"; then
        for name in "${names[@]}"; do
          if [[ -e $prefix/bin/$name || -L $prefix/bin/$name ]]; then conflict="$prefix/bin/$name"; break; fi
        done
      fi
      if [[ -n $conflict ]]; then
        has_tty || die "Unmanaged binary at $conflict; choose --prefix PATH"
        printf 'Unmanaged binary at %s. Enter another absolute install prefix: ' "$conflict" > /dev/tty
        read -r prefix < /dev/tty
        continue
      fi
      writable_parent="$prefix"
      while [[ ! -e $writable_parent && ! -L $writable_parent ]]; do
        writable_parent="${writable_parent%/*}"
        [[ -n $writable_parent ]] || writable_parent='/'
      done
      if [[ ! -w $writable_parent ]]; then
        has_tty || die "Cannot write below $writable_parent; choose --prefix PATH"
        printf 'Cannot write below %s. Enter another absolute install prefix: ' "$writable_parent" > /dev/tty
        read -r prefix < /dev/tty
        continue
      fi
      resolved=1
      break
    done
    ((resolved)) || die 'Could not select a writable install prefix'
  fi
  [[ $prefix == /* && $prefix != / && $prefix != /usr && $prefix != /bin ]] || die 'Prefix must be an absolute application install prefix'
  [[ $prefix != *'/../'* && $prefix != */.. && $prefix != *'/./'* ]] || die 'Prefix cannot contain . or .. components'
  prefix="${prefix%/}"
  [[ ! -e $prefix || -d $prefix ]] || die "Prefix exists and is not a directory: $prefix"
  if [[ $prefix == "$system_prefix" || $scope == system ]] && ((EUID != 0)) && [[ $command != status ]]; then
    die 'System install needs root; run the command with sudo'
  fi
  if ((service_requested)); then
    ((EUID == 0)) || die '--service needs root'
    [[ $scope != user ]] || die '--service needs a system installation'
    [[ $prefix != "$user_prefix" ]] || die '--service cannot use a user prefix'
  fi
fi

state_file=$(state_path "${prefix:-$user_prefix}")
versions_dir="${prefix:-$user_prefix}/lib/retractordb/versions"
if [[ $scope == user ]] || ((EUID != 0)); then
  config_base="${XDG_CONFIG_HOME:-$HOME/.config}"
  config_file="$config_base/retractor/retractor.toml"
else
  config_file='/etc/retractor/retractor.toml'
fi

read_state() {
  has_state "$prefix" || die "No managed installation in $prefix"
  installed_version=$(cat "$state_file")
  [[ $installed_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Invalid installer state in $state_file"
}

own_service() {
  [[ -f $unit_file ]] && grep -Fqx "$unit_marker" "$unit_file" &&
    grep -Fqx "ExecStart=$prefix/bin/xretractor --service --noanykey \${RETRACTOR_QUERY_FILE}" "$unit_file"
}

service_preflight() {
  ((EUID == 0)) || die 'A systemd service needs root'
  command -v systemctl >/dev/null || die 'systemctl is required for --service'
  [[ -d /run/systemd/system ]] || die 'This host is not running systemd'
  [[ ! -L $unit_file ]] || die 'Service unit path cannot be a symlink'
  python3 - "$prefix" <<'PY'
from pathlib import Path
import stat, sys
install_path = Path(sys.argv[1])
for directory in (install_path, *install_path.parents):
    try:
        mode = directory.lstat()
    except FileNotFoundError:
        continue
    if not stat.S_ISDIR(mode.st_mode) or mode.st_uid != 0 or mode.st_mode & 0o022:
        sys.exit(f'Service install path is not root-owned and protected: {directory}')
PY
  if [[ -e $unit_file || -L $unit_file ]]; then
    own_service || die "Existing unmanaged unit at $unit_file"
  elif systemctl cat xretractor.service >/dev/null 2>&1; then
    die 'An xretractor.service from another installation already exists'
  fi
  if ! getent passwd retractor >/dev/null 2>&1; then
    command -v useradd >/dev/null || die 'useradd is required to create the service account'
  fi
}

install_service() {
  service_preflight
  local already_installed=0
  if own_service; then already_installed=1; fi
  [[ ! -L /etc/retractor && ! -L /etc/retractor/startup.rql ]] || die 'Service paths cannot be symlinks'
  if ! getent passwd retractor >/dev/null 2>&1; then
    service_shell=$(type -P nologin || true)
    if [[ -z $service_shell ]]; then service_shell='/bin/false'; fi
    [[ -x $service_shell ]] || die 'No non-login shell available for the service account'
    useradd --system --user-group --no-create-home --shell "$service_shell" retractor
  fi
  if [[ ! -d /etc/retractor ]]; then
    mkdir /etc/retractor
    chown retractor:retractor /etc/retractor
  fi
  if [[ ! -e /etc/retractor/startup.rql ]]; then
    : > /etc/retractor/startup.rql
    chown retractor:retractor /etc/retractor/startup.rql
  fi
  cat > "$tmp/xretractor.service" <<UNIT
$unit_marker
[Unit]
Description=RetractorDB continuous query engine
After=network.target

[Service]
Type=simple
User=retractor
Group=retractor
Environment=RETRACTOR_QUERY_FILE=/etc/retractor/startup.rql
EnvironmentFile=-/etc/retractor/service.env
ExecStart=$prefix/bin/xretractor --service --noanykey \${RETRACTOR_QUERY_FILE}
KillSignal=SIGTERM
TimeoutStopSec=30
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
  install -m 0644 "$tmp/xretractor.service" "$unit_file"
  systemctl daemon-reload
  systemctl enable --now xretractor.service
  if ((already_installed)); then systemctl restart xretractor.service; fi
  say 'xretractor.service is enabled and running'
}

install_config() {
  local packaged_config="$versions_dir/$selected_version/share/retractordb/retractor.toml"
  [[ -f $packaged_config ]] || die "Missing packaged configuration: $packaged_config"
  if [[ -e $config_file || -L $config_file ]]; then
    [[ -f $config_file ]] || die "Configuration path is not a file: $config_file"
    say "Using existing configuration at $config_file"
    return
  fi
  if [[ $config_file == /etc/* && -L /etc/retractor ]]; then
    die 'System configuration directory cannot be a symlink'
  fi
  mkdir -p "$(dirname "$config_file")"
  install -m 0644 "$packaged_config" "$config_file"
  say "Configuration installed at $config_file"
}

asset_for() { printf 'retractordb-%s-linux-%s-portable.tar.gz' "$1" "$arch"; }
fetch_json() { curl -fsSL --retry 3 -H 'Accept: application/vnd.github+json' "$1" -o "$2"; }

case "$command" in
  status)
    read_state
    say "Installed $installed_version in $prefix"
    if own_service; then say 'Managed systemd service is installed'; fi
    if [[ -f $config_file ]]; then say "Configuration: $config_file"; fi
    for name in "${names[@]}"; do
      printf '%s -> %s\n' "$prefix/bin/$name" "$(readlink "$prefix/bin/$name" || true)"
    done
    exit 0 ;;
  uninstall)
    read_state
    [[ ! -L $versions_dir && -d $versions_dir ]] || die "Changed versions directory: $versions_dir"
    [[ ! -L $versions_dir/$installed_version && -d $versions_dir/$installed_version ]] || die 'Changed installed version directory'
    for name in "${names[@]}"; do
      link="$prefix/bin/$name"
      expected="$versions_dir/$installed_version/bin/$name"
      [[ -L $link && $(readlink "$link") == "$expected" ]] || die "Refusing to remove changed link: $link"
    done
    if own_service; then
      ((EUID == 0)) || die 'Removing the managed systemd service needs root'
      systemctl disable --now xretractor.service
      rm -- "$unit_file"
      systemctl daemon-reload
    fi
    for name in "${names[@]}"; do rm -- "$prefix/bin/$name"; done
    rm -- "$state_file"
    rm -r -- "$versions_dir/$installed_version"
    say "Removed $installed_version from $prefix"
    exit 0 ;;
esac

tmp=$(mktemp -d)
cleanup() {
  if [[ ${committed:-0} == 0 && -n ${transaction_target:-} ]]; then
    for name in "${names[@]}"; do
      link="$prefix/bin/$name"
      if [[ -L $link && $(readlink "$link") == "$transaction_target/bin/$name" ]]; then
        if [[ -n ${installed_version:-} ]]; then
          ln -s "$versions_dir/$installed_version/bin/$name" "$link_staging/$name.rollback"
          mv -Tf -- "$link_staging/$name.rollback" "$link"
        else
          rm -- "$link"
        fi
      fi
    done
    rm -r -- "$transaction_target" 2>/dev/null || true
  fi
  if [[ -n ${link_staging:-} ]]; then rm -r -- "$link_staging" 2>/dev/null || true; fi
  rm -rf -- "$tmp"
}
trap cleanup EXIT

if [[ $command == list ]]; then
  fetch_json "$api?per_page=100" "$tmp/releases.json"
  python3 - "$tmp/releases.json" "$arch" <<'PY'
import json, re, sys
with open(sys.argv[1], encoding='utf-8') as source:
    releases = json.load(source)
available = []
for release in releases:
    if release.get('draft') or release.get('prerelease'):
        continue
    tag = release.get('tag_name', '')
    version = tag[1:] if tag.startswith('v') else tag
    if not re.fullmatch(r'\d+\.\d+\.\d+', version):
        continue
    name = f"retractordb-{version}-linux-{sys.argv[2]}-portable.tar.gz"
    if any(asset.get('name') == name for asset in release.get('assets', [])):
        available.append((tuple(map(int, version.split('.'))), tag))
for _, tag in sorted(available, reverse=True):
    print(tag)
PY
  exit 0
fi

if [[ $command == upgrade ]]; then read_state; fi
if [[ -n $version ]]; then
  tag="v${version#v}"
  fetch_json "$api/tags/$tag" "$tmp/release.json"
else
  fetch_json "$api?per_page=100" "$tmp/release.json"
fi

IFS=$'\t' read -r selected_version download_url digest < <(
  python3 - "$tmp/release.json" "$arch" "$repo" <<'PY'
import json, re, sys
with open(sys.argv[1], encoding='utf-8') as source:
    records = json.load(source)
if isinstance(records, list):
    candidates = []
    for item in records:
        tag = item.get('tag_name', '')
        candidate_version = tag[1:] if tag.startswith('v') else tag
        if item.get('draft') or item.get('prerelease') or not re.fullmatch(r'\d+\.\d+\.\d+', candidate_version):
            continue
        candidate_asset = f'retractordb-{candidate_version}-linux-{sys.argv[2]}-portable.tar.gz'
        if any(asset.get('name') == candidate_asset for asset in item.get('assets', [])):
            candidates.append((tuple(map(int, candidate_version.split('.'))), item))
    if not candidates:
        sys.exit(f'No stable portable release for {sys.argv[2]}')
    release = max(candidates, key=lambda candidate: candidate[0])[1]
else:
    release = records
tag = release.get('tag_name', '')
version = tag[1:] if tag.startswith('v') else tag
if release.get('draft') or release.get('prerelease') or not re.fullmatch(r'\d+\.\d+\.\d+', version):
    sys.exit('No stable release with a numeric version was found')
asset_name = f'retractordb-{version}-linux-{sys.argv[2]}-portable.tar.gz'
for asset in release.get('assets', []):
    url = asset.get('browser_download_url', '')
    digest = asset.get('digest', '') or ''
    if asset.get('name') == asset_name and url.startswith(f'https://github.com/{sys.argv[3]}/releases/download/'):
        if not re.fullmatch(r'sha256:[0-9a-fA-F]{64}', digest):
            sys.exit(f'{asset_name} has no SHA-256 digest in GitHub Releases')
        print(version, url, digest.split(':', 1)[1], sep='\t')
        break
else:
    sys.exit(f'No {asset_name} asset in this release')
PY
)
[[ -n ${selected_version:-} ]] || die 'Release selection failed'

if has_state "$prefix"; then
  read_state
  if [[ $installed_version == "$selected_version" ]]; then
    say "$selected_version is already installed in $prefix"
    install_config
    if ((service_requested)); then install_service; fi
    exit 0
  fi
fi

if [[ $command == upgrade && -n ${installed_version:-} && $installed_version != "$selected_version" ]]; then
  newest=$(printf '%s\n%s\n' "$installed_version" "$selected_version" | sort -V | tail -1)
  [[ $newest == "$selected_version" ]] || die "Release $selected_version is older than installed $installed_version"
fi

if ((service_requested)) || own_service; then service_preflight; fi

say "Downloading $selected_version for $arch"
curl -fL --retry 3 --progress-bar "$download_url" -o "$tmp/archive.tar.gz"
printf '%s  %s\n' "$digest" "$tmp/archive.tar.gz" | sha256sum -c - >/dev/null || die 'SHA-256 mismatch'

mkdir -p "$tmp/bin"
python3 - "$tmp/archive.tar.gz" "$tmp/bin" "$machine" "$tmp/LICENSE" "$tmp/retractor.toml" <<'PY'
import os, struct, sys, tarfile
required = {'bin/xretractor', 'bin/xqry', 'bin/xtrdb'}
license_name = 'share/doc/retractordb/LICENSE'
config_name = 'share/retractordb/retractor.toml'
with tarfile.open(sys.argv[1], 'r:gz') as archive:
    members = archive.getmembers()
    found = {member.name for member in members if member.isfile()}
    if found != required | {license_name, config_name} or any(not (member.isfile() or member.isdir()) for member in members):
        sys.exit('Unexpected portable archive contents')
    for member in members:
        if member.isdir() and member.name.rstrip('/') not in {'bin', 'share', 'share/doc', 'share/doc/retractordb', 'share/retractordb'}:
            sys.exit('Unexpected directory in portable archive')
    for name in sorted(required):
        with archive.extractfile(name) as source:
            content = source.read()
        if content[:4] != b'\x7fELF' or struct.unpack_from('<H', content, 18)[0] != int(sys.argv[3]):
            sys.exit(f'{name} has the wrong ELF architecture')
        destination = os.path.join(sys.argv[2], os.path.basename(name))
        with open(destination, 'wb') as output:
            output.write(content)
        os.chmod(destination, 0o755)
    with archive.extractfile(license_name) as source:
        with open(sys.argv[4], 'wb') as output:
            output.write(source.read())
    with archive.extractfile(config_name) as source:
        with open(sys.argv[5], 'wb') as output:
            output.write(source.read())
PY

"$tmp/bin/xretractor" --build-info >/dev/null 2>"$tmp/abi-error" || {
  cat "$tmp/abi-error" >&2
  die 'This release cannot run on this Linux system (libc or libstdc++ may be too old)'
}
for name in xqry xtrdb; do
  "$tmp/bin/$name" -h >/dev/null 2>"$tmp/abi-error" || {
    cat "$tmp/abi-error" >&2
    die "$name cannot run on this Linux system"
  }
done

target="$versions_dir/$selected_version"
[[ ! -e $target && ! -L $target ]] || die "Version directory already exists: $target"
for name in "${names[@]}"; do
  link="$prefix/bin/$name"
  if [[ -e $link || -L $link ]]; then
    expected="$versions_dir/${installed_version:-}/bin/$name"
    [[ -L $link && $(readlink "$link") == "$expected" ]] || die "Unmanaged binary at $link; choose another prefix"
  fi
done

[[ ! -L $versions_dir ]] || die "Versions directory is a symlink: $versions_dir"
[[ ! -L $prefix/bin ]] || die "Binary directory is a symlink: $prefix/bin"
mkdir -p "$versions_dir" "$prefix/bin"
mkdir "$target"
transaction_target="$target"
mv -- "$tmp/bin" "$target/bin"
mkdir -p "$target/share/doc/retractordb"
mv -- "$tmp/LICENSE" "$target/share/doc/retractordb/LICENSE"
mkdir -p "$target/share/retractordb"
mv -- "$tmp/retractor.toml" "$target/share/retractordb/retractor.toml"
link_staging=$(mktemp -d "$prefix/bin/.rdb-links.XXXXXX")
for name in "${names[@]}"; do
  ln -s "$target/bin/$name" "$link_staging/$name"
done
for name in "${names[@]}"; do
  mv -Tf -- "$link_staging/$name" "$prefix/bin/$name"
done
printf '%s\n' "$selected_version" > "$tmp/installer-state"
mv -f -- "$tmp/installer-state" "$state_file"
committed=1
if [[ -n ${installed_version:-} ]]; then rm -r -- "$versions_dir/$installed_version"; fi
say "Installed $selected_version in $prefix"
install_config
if ((service_requested)) || own_service; then install_service; fi
case ":$PATH:" in *":$prefix/bin:"*) ;; *) say "Add $prefix/bin to PATH" ;; esac
