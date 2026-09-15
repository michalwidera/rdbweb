---
layout: home
permalink: /install/
lang: en
lang_alt: /pl/install/
title: "Install RetractorDB"
excerpt: "Install, update or remove RetractorDB from a GitHub release on x86-64 or ARM64 Linux."
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Linux CLI &nbsp;·&nbsp; x86-64 and ARM64</span>
      <h1>One command.<br>Three binaries, <em>verified</em>.</h1>
      <p class="lede">
        The installer downloads a published portable CLI archive from GitHub
        Releases, detects x86-64 or ARM64 (<code>aarch64</code>), checks the
        archive&rsquo;s SHA-256 digest, ELF architecture and runtime
        compatibility, then installs <code>xretractor</code>, <code>xqry</code>
        and <code>xtrdb</code>. A systemd service is available on request.
      </p>

      <div class="example" data-tabs-root>
        <div class="code-card">
          <div class="code-bar" role="tablist">
            <button class="tab on" type="button" role="tab" aria-selected="true" data-tab="user">User</button>
            <button class="tab" type="button" role="tab" aria-selected="false" data-tab="system">System</button>
            <button class="tab" type="button" role="tab" aria-selected="false" data-tab="service">System + service</button>
            <span class="code-caption" data-caption>~/.local</span>
          </div>
          <div class="code-panel" role="tabpanel" data-tab="user" data-caption="~/.local">
            <div class="code">
              <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- install --user</div>
              <div class="gap"></div>
              <div><span class="cm"># commands are linked from ~/.local/bin; add it to PATH if asked</span></div>
              <div>xretractor --build-info</div>
            </div>
          </div>
          <div class="code-panel" role="tabpanel" data-tab="system" data-caption="/usr/local" hidden>
            <div class="code">
              <div>curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- install --system</div>
            </div>
          </div>
          <div class="code-panel" role="tabpanel" data-tab="service" data-caption="/usr/local  ·  systemd" hidden>
            <div class="code">
              <div>curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- install --system --service</div>
              <div>systemctl status xretractor.service</div>
            </div>
          </div>
        </div>
      </div>

      <div class="cta-row">
        <a class="btn btn-primary" href="https://github.com/michalwidera/retractordb/releases">{% include icons/github.svg %}GitHub Releases</a>
        <a class="btn btn-ghost" href="#review">Review the script first</a>
      </div>
      <span class="hero-note">
        Requires a published <code>*-portable.tar.gz</code> archive for your CPU &nbsp;·&nbsp;
        run <code>list</code> to check; until those archives are added, the list is empty
      </span>
    </div>
  </section>

  <section id="what">
    <div class="home-in">
      <span class="sec-eyebrow">What it does</span>
      <h2>Checks first, installs second, keeps what is yours</h2>
      <div class="cards-3">
        <div class="feature">
          <h3>Checked</h3>
          <p>SHA-256 digest, ELF architecture and runtime compatibility are verified before anything is installed. On an ARM 32-bit host, a musl-based distribution, or a host with an older <code>glibc</code>/<code>libstdc++</code> than the release requires, the check stops and shows the cause &mdash; such hosts may need a dedicated build.</p>
        </div>
        <div class="feature">
          <h3>Configured</h3>
          <p>The archive includes a <code>retractor.toml</code> with safe default settings. It is copied to <code>/etc/retractor/retractor.toml</code> for a system install, or to <code>~/.config/retractor/retractor.toml</code> (or <code>XDG_CONFIG_HOME</code>) for a user install &mdash; only when absent. <code>xretractor</code> reads it at startup, including as a service.</p>
        </div>
        <div class="feature">
          <h3>Preserved</h3>
          <p>Upgrades and removal keep local configuration, query files and the service account. The installer only removes binaries and the unit it created. The shipped <code>storage.dir</code> line stays commented until you create a writable storage directory.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="service" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">systemd</span>
      <h2>Run xretractor as a system service</h2>
      <p class="body">
        Add <code>--service</code> to a system install if this host runs
        systemd. The installer creates the <code>retractor</code> service
        account and an empty <code>/etc/retractor/startup.rql</code> when
        absent &mdash; the empty file starts the engine in idle mode. Existing
        query and configuration files are left untouched. For a service, the
        install path must be owned by root and not writable by other users.
      </p>
      <div class="code-card code-card-soft">
        <div class="code-bar">
          <span class="tab on">managed service</span>
          <span class="code-caption">--system</span>
        </div>
        <div class="code">
          <div><span class="cm"># the service keeps running after an upgrade</span></div>
          <div>curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- upgrade --system</div>
          <div class="gap"></div>
          <div><span class="cm"># removes the unit; query files and the service account remain</span></div>
          <div>curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- uninstall --system</div>
        </div>
      </div>
    </div>
  </section>

  <section id="versions">
    <div class="home-in">
      <span class="sec-eyebrow">Versions and maintenance</span>
      <h2>Pick a version, upgrade, check, remove</h2>
      <p class="body">
        The default is the newest stable release with an archive for your
        CPU. <code>upgrade</code> can also take <code>--version</code>.
      </p>
      <div class="code-card code-card-soft">
        <div class="code-bar">
          <span class="tab on">maintenance</span>
          <span class="code-caption">--user</span>
        </div>
        <div class="code">
          <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- list</div>
          <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- install --version 0.1.10 --user</div>
          <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- upgrade --user</div>
          <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- status --user</div>
          <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- uninstall --user</div>
        </div>
      </div>
      <p class="note">
        For a custom directory, use <code>--prefix /absolute/path</code> and
        supply the same prefix when upgrading or removing. If both user and
        system installations exist, the installer asks which one to manage.
      </p>
    </div>
  </section>

  <section id="review" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">Before you pipe to bash</span>
      <h2>Read the script, then run it</h2>
      <div class="code-card code-card-soft">
        <div class="code">
          <div>curl -fsSLO https://retractordb.com/install.sh</div>
          <div>less install.sh</div>
          <div>bash install.sh install --user</div>
        </div>
      </div>
    </div>
  </section>

  <section id="debian">
    <div class="lineage">
      <div class="lineage-head">
        <span class="sec-eyebrow">Debian or Ubuntu with systemd</span>
        <h2>Prefer a distribution-managed service?</h2>
      </div>
      <div>
        <p>
          Use the <code>.deb</code> from
          <a href="https://github.com/michalwidera/retractordb/releases">GitHub Releases</a>
          through <code>apt</code>. It installs into <code>/usr/bin</code> and
          enables the service for the next boot. Manage upgrades and removal
          with <code>apt</code> as well; the portable installer does not manage
          Debian packages.
        </p>
        <p>
          <strong>Do not install both service variants on one host:</strong>
          they use the same unit name.
        </p>
      </div>
    </div>
  </section>

</main>
