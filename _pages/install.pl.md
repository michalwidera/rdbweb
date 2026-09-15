---
layout: default
permalink: /pl/install/
lang: pl
lang_alt: /install/
title: "Instalacja RetractorDB"
eyebrow: "Linux CLI"
excerpt: "Instalacja, aktualizacja i usunięcie RetractorDB z release GitHub na Linuksie x86-64 lub ARM64."
---

Instalator pobiera opublikowane archiwum CLI z
[GitHub Releases](https://github.com/michalwidera/retractordb/releases).
Rozpoznaje x86-64 albo ARM64 (`aarch64`), sprawdza sumę SHA-256,
architekturę ELF i zgodność bibliotek, a następnie instaluje trzy programy:
`xretractor`, `xqry` i `xtrdb`. Na żądanie może uruchomić usługę systemd.
Archiwum zawiera również `retractor.toml` z bezpiecznymi ustawieniami domyślnymi.

Polecenia instalacji wymagają wydania z archiwum `*-portable.tar.gz` dla
Twojego procesora. Uruchom `list`, aby sprawdzić dostępne wersje; do czasu
dodania tych archiwów do GitHub Releases lista będzie pusta.

Instalacja dla użytkownika w `~/.local`:

```bash
curl -fsSL https://retractordb.com/install.sh | bash -s -- install --user
```

Programy będą dostępne przez `~/.local/bin`. Dodaj ten katalog do `PATH`,
jeśli instalator o to poprosi. Sprawdź wynik poleceniem
`xretractor --build-info`.

Instalacja systemowa CLI w `/usr/local`:

```bash
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- install --system
```

Dodaj `--service`, jeżeli system używa systemd i chcesz uruchomić
`xretractor` jako usługę:

```bash
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- install --system --service
systemctl status xretractor.service
```

Dla usługi ścieżka instalacji musi należeć do roota i nie może być
zapisywalna przez innych użytkowników.

Później zaktualizuj lub usuń tę zarządzaną usługę poleceniami:

```bash
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- upgrade --system
curl -fsSL https://retractordb.com/install.sh | sudo bash -s -- uninstall --system
```

Instalator tworzy konto usługi `retractor` i pusty plik
`/etc/retractor/startup.rql`, jeżeli jeszcze nie istnieją. Pusty plik
uruchamia silnik w trybie bezczynnym. Istniejące zapytania i konfiguracja
pozostają bez zmian.

Instalator kopiuje `retractor.toml` do `/etc/retractor/retractor.toml` przy
instalacji systemowej, a do `~/.config/retractor/retractor.toml` (lub katalogu
`XDG_CONFIG_HOME`) przy instalacji użytkownika. Robi to tylko wtedy, gdy plik
jeszcze nie istnieje. `xretractor` automatycznie wczytuje tę konfigurację
przy starcie, także jako usługa. Aktualizacja i usunięcie zachowują własny
plik konfiguracyjny. Dyrektywa `storage.dir` w dostarczonym pliku jest
zakomentowana do czasu utworzenia katalogu z prawem zapisu.

Możesz najpierw przeczytać pobrany skrypt:

```bash
curl -fsSLO https://retractordb.com/install.sh
less install.sh
bash install.sh install --user
```

## Wersje i utrzymanie

Domyślnie instalowana jest najnowsza stabilna wersja z paczką dla
Twojego procesora. Wersję można wybrać samodzielnie:

```bash
curl -fsSL https://retractordb.com/install.sh | bash -s -- list
curl -fsSL https://retractordb.com/install.sh | bash -s -- install --version 0.1.10 --user
curl -fsSL https://retractordb.com/install.sh | bash -s -- upgrade --user
curl -fsSL https://retractordb.com/install.sh | bash -s -- status --user
curl -fsSL https://retractordb.com/install.sh | bash -s -- uninstall --user
```

`upgrade` również przyjmuje `--version`. Zarządzana usługa zostaje
uruchomiona z nowym binarium, a `uninstall` usuwa jej jednostkę. Pliki
zapytań i konto usługi pozostają. Instalator usuwa wyłącznie swoje programy
i jednostkę systemd. Dla własnego katalogu podaj
`--prefix /sciezka/bezwzgledna` także przy aktualizacji i usuwaniu.
Jeżeli istnieje instalacja użytkownika i systemowa, instalator zapyta,
którą obsłużyć.

ARM 32-bit, dystrybucja oparta na musl lub system ze starszą wersją
`glibc`/`libstdc++` mogą wymagać osobnej kompilacji. Kontrola zgodności
zatrzyma instalację i poda przyczynę.

## Debian lub Ubuntu z systemd

Jeżeli wolisz usługę zarządzaną przez dystrybucję, zainstaluj `.deb` z
[GitHub Releases](https://github.com/michalwidera/retractordb/releases)
przez `apt`. Paczka instaluje programy w `/usr/bin` i włącza usługę
na następny start systemu. Aktualizację i usunięcie wykonuj również przez
`apt`; instalator przenośnej paczki nie zarządza paczkami Debiana. Nie
instaluj obu wariantów usługi na jednej maszynie: mają tę samą nazwę jednostki.
