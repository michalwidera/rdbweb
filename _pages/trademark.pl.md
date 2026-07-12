---
layout: default
permalink: /pl/trademark/
lang: pl
lang_alt: /trademark/
title: "Zasady użycia znaku towarowego"
eyebrow: "Marka"
excerpt: "Jak zapisywać nazwę słowną RetractorDB oraz co oznacza znak graficzny nożyc."
toc: true
---

Znaki towarowe mówią światu, kto jest źródłem danego dobra lub usługi.
Ochrona znaku dla projektu open source ma znaczenie właśnie dlatego, że
każdy może zrobić fork kodu: ograniczenie użycia znaków towarowych
RetractorDB pozwala użytkownikom wiedzieć, że mają do czynienia z
produktem samego projektu albo wariantem przez niego zatwierdzonym, a
nie czyjąś zmodyfikowaną wersją pod tą samą nazwą.

Znak towarowy RetractorDB obejmuje jeden znak słowny &mdash;
**RetractorDB** &mdash; chroniony prawem wyłącznym
[R.332224](https://ewyszukiwarka.pue.uprp.gov.pl/search/pwp-details/Z.509860?lng=pl)
udzielonym przez Urząd Patentowy Rzeczypospolitej Polskiej.

## Znak słowny

RetractorDB zapisuje się jako jedno słowo, bez spacji. **Retractor**
zaczyna się wielką literą; **DB** jest zawsze zapisane wielkimi
literami. Krój pisma to **Ubuntu Italic**. &bdquo;Retractor&rdquo; jest
czarny na jasnym tle, biały na ciemnym tle. &bdquo;DB&rdquo; jest zawsze
w kolorze błękitnym, `#6699FF`.

<p class="panel-card" style="font-family:'Ubuntu',sans-serif;font-style:italic;font-size:32px">
  Retractor<span style="color:#6699FF">DB</span>
</p>

```html
<link href="https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;1,300&display=swap" rel="stylesheet">
<i><font face="Ubuntu">Retractor</font><font face="Ubuntu" color="#6699FF">DB</font></i>
```

Znak słowny jest też dostępny jako gotowa grafika SVG, w tych samych
dwóch wariantach tła co znak graficzny poniżej:

<div class="panel-card" style="display:flex;gap:32px;align-items:center;flex-wrap:wrap">
  <img src="{{ '/assets/images/retractordb.svg' | relative_url }}" alt="Znak słowny RetractorDB, wersja na jasne tło" width="220" height="35">
  <div style="background:#101114;padding:16px;border-radius:8px">
    <img src="{{ '/assets/images/retractordb-onblack.svg' | relative_url }}" alt="Znak słowny RetractorDB, wersja na ciemne tło" width="220" height="35">
  </div>
</div>

<p class="body">
  <a href="{{ '/assets/images/retractordb.svg' | relative_url }}" download>Pobierz wersję na jasne tło (.svg)</a>
  &nbsp;&middot;&nbsp;
  <a href="{{ '/assets/images/retractordb-onblack.svg' | relative_url }}" download>Pobierz wersję na ciemne tło (.svg)</a>
</p>

## Znak graficzny: nożyce

Głównym znakiem graficznym jest **nożyce / &bdquo;przetnij tutaj&rdquo;**
&mdash; dosłowny rysunek **operatora rozplatania (de-interleave)**:
kropkowany, przeplatany strumień zostaje przecięty i rozdziela się na
dwa strumienie składowe, **A** (czarny) i **B** (niebieski, `#6699FF`).
To celowa gra słów z nazwą projektu &mdash; retractor to po angielsku
m.in. rozwieracz/ściągacz, a znak dosłownie przecina strumień na dwoje.

Znak jest rozpowszechniany jako SVG w dwóch wariantach kolorystycznych
&mdash; czarny na jasne tła, biały na ciemne tła &mdash; dzięki czemu
pozostaje ostry w każdym rozmiarze. Pierścień osi jest zawsze błękitny,
`#6699FF`, w obu wariantach.

<div class="panel-card" style="display:flex;gap:32px;align-items:center;flex-wrap:wrap">
  <img src="{{ '/assets/images/icon/scissors.svg' | relative_url }}" alt="Znak nożyc RetractorDB, czarny tusz na jasne tła" width="120" height="120">
  <div style="background:#101114;padding:16px;border-radius:8px">
    <img src="{{ '/assets/images/icon/scissors-dark.svg' | relative_url }}" alt="Znak nożyc RetractorDB, biały tusz na ciemne tła" width="120" height="120">
  </div>
</div>

<p class="body">
  <a href="{{ '/assets/images/icon/scissors.svg' | relative_url }}" download>Pobierz wersję czarną (.svg)</a>
  &nbsp;&middot;&nbsp;
  <a href="{{ '/assets/images/icon/scissors-dark.svg' | relative_url }}" download>Pobierz wersję białą (.svg)</a>
</p>

Kolejność kropek w scalonym strumieniu, gdziekolwiek jest rysowana, musi
odpowiadać prawdziwemu przeplotowi 2:3 &mdash; **A A B A B A A B A B**
&mdash; zgodnie z przykładem z dokumentacji (&Tau; = {1, 2, a, 3, b, 4,
5, c, 6, d}). Grubość linii to 16/512 z zaokrąglonymi zakończeniami,
zgodnie z oryginalnym rysunkiem nożyc.

Wcześniejszy znak z paskami &mdash; pięć pasków kodujących tę samą
sekwencję wyboru przeplotu 2:3, **A B A A B** &mdash; pozostaje ważną
grafiką historyczną (to wersja zgłoszona już do
[dbdb.io](https://dbdb.io)), ale nie jest już głównym znakiem używanym w
nawigacji, favikonach ani kartach społecznościowych.

## Zasady użycia

- Nie zmieniaj koloru znaku graficznego poza czarny / biały / `#6699FF`.
- Nie zniekształcaj, nie obracaj i nie dodawaj efektów (cienie,
  gradienty, obrysy).
- Zachowaj wokół znaku wolną przestrzeń o szerokości co najmniej jednej
  szerokości znaku z każdej strony.
- Warianty `*-onblack.svg` (znak słowny) i `*-dark.svg` (znak graficzny)
  są przeznaczone na ciemne powierzchnie; nie umieszczaj jasnego
  wariantu na ciemnym tle ani odwrotnie.
