---
layout: default
permalink: /install/
lang: en
lang_alt: /pl/install/
title: "Install RetractorDB"
eyebrow: "Linux CLI"
excerpt: "Install, update or remove RetractorDB from a GitHub release on x86-64 or ARM64 Linux."
---

The installer downloads a published portable CLI archive from
[GitHub Releases](https://github.com/michalwidera/retractordb/releases).
It detects x86-64 or ARM64 (`aarch64`), checks the archive's SHA-256 digest,
ELF architecture and runtime compatibility, then installs the three commands:
`xretractor`, `xqry` and `xtrdb`. A systemd service is available on request.
The archive also includes a `retractor.toml` with safe default settings.

These commands require a published `*-portable.tar.gz` archive for your CPU.
Run `list` to check available versions; until those archives are added to
GitHub Releases, the list will be empty.

Run this in a terminal for a user install in `~/.local`:

```bash
curl -fsSL https://retractordb.com/install.sh | bash -s -- install --user
```

The commands are linked from `~/.local/bin`. Add that directory to `PATH`
if the installer asks you to. Check the result with `xretractor --build-info`.

For a system-wide CLI install in `/usr/local`, run:

```bash
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- install --system
```

Add `--service` if this host runs systemd and you want `xretractor` to start
as a system service:

```bash
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- install --system --service
systemctl status xretractor.service
```

For a service, the install path must be owned by root and not writable by
other users.

Later, upgrade or remove this managed service with:

```bash
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- upgrade --system
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- uninstall --system
```

The installer creates the `retractor` service account and an empty
`/etc/retractor/startup.rql` when absent. The empty file starts the engine
in idle mode. It preserves existing query and configuration files.

For a system install, the installer copies `retractor.toml` to
`/etc/retractor/retractor.toml`. For a user install, it uses
`~/.config/retractor/retractor.toml` or `XDG_CONFIG_HOME`. It only creates
the file when absent. `xretractor` automatically reads it at startup,
including when started as a service. Upgrades and removal preserve local
configuration. The shipped `storage.dir` line stays commented until you
create a writable storage directory.

To review the script before executing it, download it first:

```bash
curl -fsSLO https://retractordb.com/install.sh
less install.sh
bash install.sh install --user
```

## Versions and maintenance

The default is the newest stable release with an archive for your CPU.
You can inspect available versions and select one explicitly:

```bash
curl -fsSL https://retractordb.com/install.sh | bash -s -- list
curl -fsSL https://retractordb.com/install.sh | bash -s -- install --version 0.1.10 --user
curl -fsSL https://retractordb.com/install.sh | bash -s -- upgrade --user
curl -fsSL https://retractordb.com/install.sh | bash -s -- status --user
curl -fsSL https://retractordb.com/install.sh | bash -s -- uninstall --user
```

`upgrade` can also take `--version`. A managed service keeps running after
an upgrade and is removed by `uninstall`; its query files and service account
remain. The installer only removes binaries and the unit it created.
For a custom directory, use
`--prefix /absolute/path`; supply the same prefix when upgrading or removing.
If both user and system installations exist, it asks which one to manage.

An ARM 32-bit host, a musl-based distribution, or a host with an older
`glibc`/`libstdc++` than the release requires may need a dedicated build.
The compatibility check stops before installation and shows the cause.

## Debian or Ubuntu with systemd

If you prefer a distribution-managed `xretractor` service, use the `.deb` from
[GitHub Releases](https://github.com/michalwidera/retractordb/releases)
through `apt`. The `.deb` installs into `/usr/bin` and enables the service
for the next boot. Manage upgrades and removal with `apt` as well; the
portable installer does not manage Debian packages. Do not install both
service variants on one host: they use the same unit name.
