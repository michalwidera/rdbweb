---
layout: home
permalink: /pl/install/
lang: pl
lang_alt: /install/
title: "Instalacja RetractorDB"
excerpt: "Instalacja, aktualizacja i usunięcie RetractorDB z release GitHub na Linuksie x86-64 lub ARM64."
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Linux CLI &nbsp;·&nbsp; x86-64 i ARM64</span>
      <h1>Jedno polecenie.<br>Trzy programy, <em>sprawdzone</em>.</h1>
      <p class="lede">
        Instalator pobiera opublikowane archiwum CLI z GitHub Releases,
        rozpoznaje x86-64 albo ARM64 (<code>aarch64</code>), sprawdza sumę
        SHA-256, architekturę ELF i zgodność bibliotek, a następnie instaluje
        <code>xretractor</code>, <code>xqry</code> i <code>xtrdb</code>.
        Na żądanie może uruchomić usługę systemd.
      </p>

      <div class="example" data-tabs-root>
        <div class="code-card">
          <div class="code-bar" role="tablist">
            <button class="tab on" type="button" role="tab" aria-selected="true" data-tab="user">Użytkownik</button>
            <button class="tab" type="button" role="tab" aria-selected="false" data-tab="system">System</button>
            <button class="tab" type="button" role="tab" aria-selected="false" data-tab="service">System + usługa</button>
            <span class="code-caption" data-caption>~/.local</span>
          </div>
          <div class="code-panel" role="tabpanel" data-tab="user" data-caption="~/.local">
            <div class="code">
              <div>curl -fsSL https://retractordb.com/install.sh | bash -s -- install --user</div>
              <div class="gap"></div>
              <div><span class="cm"># programy są dostępne przez ~/.local/bin; dodaj go do PATH, jeśli instalator poprosi</span></div>
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
        <a class="btn btn-ghost" href="#review">Najpierw przeczytaj skrypt</a>
      </div>
      <span class="hero-note">
        Wymaga wydania z archiwum <code>*-portable.tar.gz</code> dla Twojego procesora &nbsp;·&nbsp;
        sprawdź poleceniem <code>list</code>; do czasu dodania tych archiwów lista jest pusta
      </span>
    </div>
  </section>

  <section id="what">
    <div class="home-in">
      <span class="sec-eyebrow">Co robi instalator</span>
      <h2>Najpierw sprawdza, potem instaluje, Twoje zostawia</h2>
      <div class="cards-3">
        <div class="feature">
          <h3>Sprawdzone</h3>
          <p>Suma SHA-256, architektura ELF i zgodność bibliotek są weryfikowane przed instalacją. ARM 32-bit, dystrybucja oparta na musl lub system ze starszą wersją <code>glibc</code>/<code>libstdc++</code> mogą wymagać osobnej kompilacji &mdash; kontrola zgodności zatrzyma instalację i poda przyczynę.</p>
        </div>
        <div class="feature">
          <h3>Skonfigurowane</h3>
          <p>Archiwum zawiera <code>retractor.toml</code> z bezpiecznymi ustawieniami domyślnymi. Trafia do <code>/etc/retractor/retractor.toml</code> przy instalacji systemowej, a do <code>~/.config/retractor/retractor.toml</code> (lub <code>XDG_CONFIG_HOME</code>) przy instalacji użytkownika &mdash; tylko gdy plik nie istnieje. <code>xretractor</code> wczytuje go przy starcie, także jako usługa.</p>
        </div>
        <div class="feature">
          <h3>Zachowane</h3>
          <p>Aktualizacja i usunięcie zachowują własną konfigurację, pliki zapytań i konto usługi. Instalator usuwa wyłącznie swoje programy i jednostkę systemd. Dyrektywa <code>storage.dir</code> w dostarczonym pliku jest zakomentowana do czasu utworzenia katalogu z prawem zapisu.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="service" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">systemd</span>
      <h2>xretractor jako usługa systemowa</h2>
      <p class="body">
        Dodaj <code>--service</code> do instalacji systemowej, jeżeli system
        używa systemd. Instalator tworzy konto usługi <code>retractor</code> i
        pusty plik <code>/etc/retractor/startup.rql</code>, jeżeli jeszcze nie
        istnieją &mdash; pusty plik uruchamia silnik w trybie bezczynnym.
        Istniejące zapytania i konfiguracja pozostają bez zmian. Dla usługi
        ścieżka instalacji musi należeć do roota i nie może być zapisywalna
        przez innych użytkowników.
      </p>
      <div class="code-card code-card-soft">
        <div class="code-bar">
          <span class="tab on">zarządzana usługa</span>
          <span class="code-caption">--system</span>
        </div>
        <div class="code">
          <div><span class="cm"># usługa zostaje uruchomiona z nowym binarium</span></div>
          <div>curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- upgrade --system</div>
          <div class="gap"></div>
          <div><span class="cm"># usuwa jednostkę; pliki zapytań i konto usługi pozostają</span></div>
          <div>curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- uninstall --system</div>
        </div>
      </div>
    </div>
  </section>

  <section id="versions">
    <div class="home-in">
      <span class="sec-eyebrow">Wersje i utrzymanie</span>
      <h2>Wybierz wersję, aktualizuj, sprawdzaj, usuwaj</h2>
      <p class="body">
        Domyślnie instalowana jest najnowsza stabilna wersja z paczką dla
        Twojego procesora. <code>upgrade</code> również przyjmuje
        <code>--version</code>.
      </p>
      <div class="code-card code-card-soft">
        <div class="code-bar">
          <span class="tab on">utrzymanie</span>
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
        Dla własnego katalogu podaj <code>--prefix /sciezka/bezwzgledna</code>
        także przy aktualizacji i usuwaniu. Jeżeli istnieje instalacja
        użytkownika i systemowa, instalator zapyta, którą obsłużyć.
      </p>
    </div>
  </section>

  <section id="review" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">Zanim przekażesz do bash</span>
      <h2>Przeczytaj skrypt, potem go uruchom</h2>
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
        <span class="sec-eyebrow">Debian lub Ubuntu z systemd</span>
        <h2>Wolisz usługę zarządzaną przez dystrybucję?</h2>
      </div>
      <div>
        <p>
          Zainstaluj <code>.deb</code> z
          <a href="https://github.com/michalwidera/retractordb/releases">GitHub Releases</a>
          przez <code>apt</code>. Paczka instaluje programy w <code>/usr/bin</code>
          i włącza usługę na następny start systemu. Aktualizację i usunięcie
          wykonuj również przez <code>apt</code>; instalator przenośnej paczki
          nie zarządza paczkami Debiana.
        </p>
        <p>
          <strong>Nie instaluj obu wariantów usługi na jednej maszynie:</strong>
          mają tę samą nazwę jednostki.
        </p>
      </div>
    </div>
  </section>

</main>
