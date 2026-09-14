---
layout: home
permalink: /pl/
lang: pl
lang_alt: /
title: "RetractorDB"
seo_title: "RetractorDB — Regularne strumienie. Determinizm u podstawy."
excerpt: "RetractorDB to otwartoźródłowy Deterministyczny Brzegowy Silnik Przetwarzania Sygnałów, którego operatory resamplingu są dowiedzione jako dokładne — oparte na wymiernych ciągach Beatty'ego i twierdzeniu o podziale Fraenkla."
og_image: "/assets/images/icon/ms-icon-310x310.png"
og_image_width: 310
og_image_height: 310
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Otwartoźródłowy Deterministyczny Brzegowy Silnik Przetwarzania Sygnałów</span>
      <h1>Regularne strumienie.<br>Determinizm u <em>podstawy</em>.</h1>
      <p class="lede">
        RetractorDB scala i resampluje regularne szeregi czasowe bez błędu
        przybliżenia. Jego kluczowe operatory są dowiedzione jako poprawne w
        arytmetyce liczb wymiernych — oparte na ciągach Beatty&rsquo;ego i
        twierdzeniu o podziale Fraenkla. Odtwórz nagranie, a za każdym razem
        otrzymasz te same dane.
      </p>
      <div class="cta-row">
        <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Przeczytaj artykuł</a>
        <a class="btn btn-ghost" href="https://github.com/michalwidera/retractordb">{% include icons/github.svg %}Zobacz na GitHub</a>
      </div>
      <span class="hero-note">arXiv:2607.07730 &nbsp;·&nbsp; licencja MIT</span>

      {% include home/examples.html lang=page.lang %}
    </div>
  </section>

  <section id="idea">
    <div class="home-in">
      <span class="sec-eyebrow">Idea</span>
      <h2>Scalenie, które zawsze można cofnąć</h2>
      <p class="body">
        Regularny strumień to po prostu zegar — punkt startowy i stały odstęp
        między taktami. Dwa zegary działające z różną częstotliwością można
        utkać w jeden połączony strumień, zachowując kolejność, bez straty
        danych.
      </p>
      <div class="cards-3">
        <div class="feature">
          <div class="feature-head">
            <h3>Dokładność</h3>
            <span class="feature-icon">{% include home/feature-icons.html icon="exact" %}</span>
          </div>
          <p>Kluczowe operatory są dowiedzione w arytmetyce liczb wymiernych. Bez dryfu zmiennoprzecinkowego, bez przybliżeń — dla dowolnej pary regularnych częstotliwości.</p>
        </div>
        <div class="feature">
          <div class="feature-head">
            <h3>Odwracalność</h3>
            <span class="feature-icon">{% include home/feature-icons.html icon="reversible" %}</span>
          </div>
          <p>Połączony strumień zawsze da się rozdzielić na dokładnie te dwa zegary, z których powstał. Scalanie i rozdzielanie są operacjami odwrotnymi; znak nożyc to narysowane rozdzielenie.</p>
        </div>
        <div class="feature">
          <div class="feature-head">
            <h3>Powtarzalność</h3>
            <span class="feature-icon">{% include home/feature-icons.html icon="replay" %}</span>
          </div>
          <p>Odtwórz to samo nagranie dwa razy, a wynik będzie identyczny co do bitu — właściwość stale sprawdzana w CI.</p>
        </div>
      </div>
      <p class="note">
        Formalny dowód znajduje się w <a href="https://arxiv.org/abs/2607.07730">artykule</a>.
        Sprawdź reguły sam, używając operatorów <a href="/pl/interlace/">interlace</a>
        i <a href="/pl/sum/">sum</a>.
      </p>
    </div>
  </section>

  <section id="applications" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">Gdzie się sprawdza</span>
      <h2>Każda maszyna, która strumieniuje dane, każdy sygnał, który się liczy</h2>
      <p class="body">
        RetractorDB jest neutralny domenowo. Działa na brzegu sieci, tuż przy
        czujnikach, i zamienia surową telemetrię o różnych częstotliwościach
        próbkowania w dokładne, zredukowane, stabilne przy odtwarzaniu
        strumienie, zanim trafią do historiana, TSDB lub chmury.
      </p>
      {% include home/applications.html lang=page.lang %}
      <p class="note">
        Ten sam wzorzec powtarza się wszędzie tam, gdzie regularna telemetria
        spotyka ślad audytowy: rejestratory danych kolejowych i morskich,
        sieci sejsmiczne, monitoring stanu konstrukcji mostów i budynków,
        sieci czujników środowiskowych.
      </p>
    </div>
  </section>

  <section id="engine">
    <div class="home-in">
      <span class="sec-eyebrow">Silnik</span>
      <h2>Trzy programy, jeden deterministyczny potok</h2>
      <p class="body">
        Zadeklaruj strumienie źródłowe i ciągłe transformacje w RQL,
        deklaratywnym języku zapytań realizującym tę algebrę. Kompilator
        sprowadza każdy strumień do wymiernego interwału i buduje graf
        zależności DAG; silnik wykonawczy planuje sloty na wymiernej osi czasu.
      </p>
      <div class="cards-3">
        <div class="bin">
          <h3><span>x</span>retractor</h3>
          <p>Parser, kompilator i silnik wykonawczy dla planów RQL. Tryby tylko-kompilacji i zrzutu planu do inspekcji.</p>
        </div>
        <div class="bin">
          <h3><span>x</span>qry</h3>
          <p>Odpytuje działające strumienie na żywo przez IPC &mdash; surowo lub sformatowane, gotowe do przekierowania do gnuplot.</p>
        </div>
        <div class="bin">
          <h3><span>x</span>trdb</h3>
          <p>Inspekcja i edycja artefaktów binarnych: schemat, metadane null/luk, deterministyczne dane testowe.</p>
        </div>
      </div>

      <div class="sub-block" id="rql">
        <span class="sec-eyebrow">RQL w praktyce</span>
        <h2>Jeden przykład, ta sama algebra wszędzie</h2>
        <p class="body">
          Przykład z artykułu to dłuższy łańcuch tych samych operatorów:
          detektor zespołów QRS Pan&ndash;Tompkinsa na danych EKG MIT-BIH, od
          początku do końca w tej algebrze. Zamień współczynniki, a ten sam
          łańcuch policzy obwiednię drgań albo cechę sygnału z magistrali. Bez
          funkcji użytkownika, bez proceduralnych furtek.
        </p>
        <ol class="steps">
          <li><span>01</span>Filtr pasmowy 5–15 Hz</li>
          <li><span>02</span>Pochodna</li>
          <li><span>03</span>Kwadrat</li>
          <li><span>04</span>Całkowanie w oknie ruchomym</li>
          <li><span>05</span>Próg adaptacyjny</li>
        </ol>
        {% include home/qrs-example.html lang=page.lang %}
      </div>
    </div>
  </section>

  <section id="lineage">
    <div class="lineage">
      <div class="lineage-head">
        <span class="sec-eyebrow">Rodowód</span>
        <h2>Stulecie matematyki, jeden silnik</h2>
      </div>
      <ol class="tl-list">
        <li>
          <span class="tl-year">1926</span><span class="tl-dot"></span>
          <p>Beatty pokazuje, że dwa ciągi &lfloor;np&rfloor;, &lfloor;nq&rfloor; dzielą &#8469; dla niewymiernych częstotliwości.</p>
        </li>
        <li>
          <span class="tl-year">1969</span><span class="tl-dot"></span>
          <p>Fraenkel uogólnia kryterium podziału na parametry <strong>wymierne</strong> &mdash; <a href="https://planetmath.org/fraenkelspartitiontheorem">przypadek obliczalny</a>.</p>
        </li>
        <li>
          <span class="tl-year">2003</span><span class="tl-dot"></span>
          <p>Algebra operatorów i deklaratywny język zapytań zostają zdefiniowane w kontekście monitorowania płodu [JMIT t. 5&ndash;6].</p>
        </li>
        <li>
          <span class="tl-year">2006</span><span class="tl-dot"></span>
          <p>Most między systemami pokryć a wyrównywaniem strumieni zostaje ustanowiony w recenzowanej publikacji [Annales UMCS Informatica t. 4] &mdash; dziś na <a href="https://arxiv.org/abs/2607.10444">arXiv:2607.10444</a>.</p>
        </li>
        <li>
          <span class="tl-year">2026</span><span class="tl-dot"></span>
          <p>Pełna formalna semantyka, dowody i raport z silnika: <a href="https://arxiv.org/abs/2607.07730">arXiv:2607.07730</a>.</p>
        </li>
      </ol>
    </div>
  </section>

</main>
