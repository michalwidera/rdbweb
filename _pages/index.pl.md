---
layout: home
permalink: /pl/
lang: pl
lang_alt: /
title: "RetractorDB"
seo_title: "RetractorDB — Dokładne strumienie. Deterministyczne z twierdzenia."
excerpt: "RetractorDB to otwartoźródłowy Deterministic Edge Signal Processing Engine, którego operatory resamplingu są dowiedzione jako dokładne — oparte na wymiernych ciągach Beatty'ego i twierdzeniu o podziale Fraenkla."
fontawesome: true
og_image: "/assets/images/icon/ms-icon-310x310.png"
og_image_width: 310
og_image_height: 310
---

<header class="home-hero">
  <div class="hero">
    <span class="eyebrow">Otwartoźródłowy Deterministic Edge Signal Processing Engine</span>
    <h1>Dokładne strumienie.<br>Deterministyczne <em>z twierdzenia</em>.</h1>
    <p class="lede">
      RetractorDB scala i resampluje regularne szeregi czasowe bez błędu
      przybliżenia. Jego kluczowe operatory są dowiedzione jako poprawne w
      arytmetyce liczb wymiernych — oparte na ciągach Beatty&rsquo;ego i
      twierdzeniu o podziale Fraenkla. Odtwórz nagranie, a za każdym razem
      otrzymasz te same bity.
    </p>
    <div class="cta-row">
      <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Przeczytaj artykuł</a>
      <a class="btn btn-ghost" href="https://github.com/michalwidera/retractordb">Zobacz na GitHub</a>
    </div>
    <p class="hero-note">arXiv:2607.07730 &nbsp;·&nbsp; licencja MIT</p>

    {% include home/merge-diagram.html lang=page.lang %}
  </div>
</header>

<main class="home">

  <section id="idea">
    <div class="wrap">
      <span class="sec-eyebrow">Idea</span>
      <h2>Scalenie, które zawsze można cofnąć</h2>
      <p class="body">
        Większość systemów strumieniowych znakuje każde zdarzenie znacznikiem
        czasu i uzgadnia je w rozmytych oknach czasowych. RetractorDB zaczyna
        od czegoś prostszego: regularny strumień to po prostu zegar — punkt
        startowy i stały odstęp między taktami. Dwa zegary działające z różną
        częstotliwością można utkać w jeden połączony strumień, zachowując
        kolejność, bez straty niczego.
      </p>
      <p class="body">
        Najważniejsze jest to, że ten połączony strumień zawsze można
        rozdzielić z powrotem na dokładnie te dwa zegary, z których powstał
        &mdash; bez przybliżeń, bez dryfu, bez zgadywania, który takt
        pochodził z którego strumienia. Scalanie i rozdzielanie są dokładnie
        odwrotnymi operacjami, dla dowolnej pary regularnych częstotliwości.
        Odtwórz to samo nagranie dwa razy, a wynik będzie identyczny co do
        bitu, bo operacja nigdy nie była przybliżona.
      </p>
      <p class="body">
        Stąd też biorą się znaki graficzne &mdash; znak nożyc to dosłownie
        narysowana operacja rozdzielenia.
      </p>
      <div class="legend">
        <span class="chip"><span class="dot a"></span> strumień A</span>
        <span class="chip"><span class="dot b"></span> strumień B</span>
      </div>
      <p class="hero-note" style="margin-top:8px">
        Formalny dowód &mdash; oparty na teorii liczb &mdash; znajduje się w
        <a href="https://arxiv.org/abs/2607.07730">artykule</a>, dla ciekawskich.
      </p>
      <p class="hero-note">
        Chcesz sam zobaczyć te reguły w działaniu? Wypróbuj operatory
        <a href="/pl/interlace/">interlace</a> i <a href="/pl/sum/">sum</a>
        na własnych ciągach i częstotliwościach.
      </p>
    </div>
  </section>

  <section id="applications">
    <div class="wrap">
      <span class="sec-eyebrow">Gdzie się sprawdza</span>
      <h2>Każda maszyna, która strumieniuje dane, każdy sygnał, który się liczy</h2>
      <p class="body">
        RetractorDB jest neutralny domenowo. Działa na brzegu sieci, tuż przy
        czujnikach, i zamienia surową telemetrię o różnych częstotliwościach
        próbkowania w dokładne, zredukowane, stabilne przy odtwarzaniu
        strumienie, zanim trafią do historiana, TSDB lub chmury. Wszędzie
        tam, gdzie sygnały o różnych częstotliwościach próbkowania trzeba
        scalać, resamplować i audytować, algebra działa bez zmian &mdash;
        różnią się jedynie współczynniki.
      </p>
      {% assign apps = site.data.applications %}
      {% if page.lang == "pl" %}{% assign apps = site.data.applications_pl %}{% endif %}
      <div class="carousel">
        <div class="carousel-track">
          {% for app in apps %}
          <div class="card">
            <h3><i class="fa-solid {{ app.icon }}"></i>{{ app.title }}</h3>
            <p>{{ app.text }}</p>
          </div>
          {% endfor %}
          {% for app in apps %}
          <div class="card" aria-hidden="true">
            <h3><i class="fa-solid {{ app.icon }}"></i>{{ app.title }}</h3>
            <p>{{ app.text }}</p>
          </div>
          {% endfor %}
        </div>
      </div>
      <p class="body" style="margin-top:26px">
        Ten sam wzorzec powtarza się wszędzie tam, gdzie regularna telemetria
        spotyka ślad audytowy: rejestratory danych kolejowych i morskich,
        sieci sejsmiczne, monitoring stanu konstrukcji mostów i budynków,
        sieci czujników środowiskowych.
      </p>
    </div>
  </section>

  <section id="engine">
    <div class="wrap">
      <span class="sec-eyebrow">Silnik</span>
      <h2>Trzy programy, jeden deterministyczny potok</h2>
      <p class="body">
        Zadeklaruj strumienie źródłowe i ciągłe transformacje w RQL,
        deklaratywnym języku zapytań realizującym tę algebrę. Kompilator
        sprowadza każdy strumień do wymiernego interwału i buduje graf
        zależności DAG; silnik wykonawczy planuje sloty na wymiernej osi
        czasu. Identyczne dane wejściowe dają artefakty identyczne co do
        bajtu &mdash; właściwość stale sprawdzana w CI.
      </p>
      <div class="cards">
        <div class="card">
          <h3><span>x</span>retractor</h3>
          <p>Parser, kompilator i silnik wykonawczy dla planów RQL. Tryby tylko-kompilacji i zrzutu planu do inspekcji.</p>
        </div>
        <div class="card">
          <h3><span>x</span>qry</h3>
          <p>Odpytuje działające strumienie na żywo przez IPC &mdash; surowo lub sformatowane, gotowe do przekierowania do gnuplot.</p>
        </div>
        <div class="card">
          <h3><span>x</span>trdb</h3>
          <p>Inspekcja i edycja artefaktów binarnych: schemat, metadane null/luk, deterministyczne dane testowe.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="rql">
    <div class="wrap">
      <span class="sec-eyebrow">RQL w praktyce</span>
      <h2>Jeden przykład, ta sama algebra wszędzie</h2>
      <p class="body">
        Każda z domen wymienionych wyżej sprowadza się do tego samego
        łańcucha operatorów. Jako przykład w artykule wybraliśmy wymagający,
        dobrze opisany potok z pierwotnej domeny silnika: detektor zespołów
        QRS Pan&ndash;Tompkinsa na danych EKG MIT-BIH &mdash; filtr
        pasmowoprzepustowy, pochodna, podniesienie do kwadratu, całkowanie,
        próg adaptacyjny &mdash; wszystko od początku do końca w tej
        algebrze. Zamień współczynniki, a ten sam łańcuch policzy obwiednię
        drgań albo cechę sygnału z magistrali. Bez funkcji użytkownika, bez
        proceduralnych furtek.
      </p>
      <pre class="code"><span class="kw">DECLARE</span> MLII INTEGER, V1 INTEGER <span class="kw">STREAM</span> ecg, 1/360 <span class="kw">FILE</span> 'rec205'

<span class="cm"># 1. filtr pasmowoprzepustowy 5–15 Hz — konwolucja FIR, 25 odczepów</span>
<span class="kw">SELECT</span> * <span class="kw">STREAM</span> mlii_win <span class="kw">FROM</span> mlii@(1,25)
<span class="kw">SELECT</span> mlii_win[_]*bpf[_] <span class="kw">STREAM</span> bp_acc <span class="kw">FROM</span> mlii_win+bpf

<span class="cm"># 2. pochodna   3. podniesienie do kwadratu   4. całkowanie w oknie ruchomym</span>
<span class="kw">SELECT</span> d_out[0]*d_out[0]/1000 <span class="kw">STREAM</span> sq_out <span class="kw">FROM</span> d_out

<span class="cm"># 5. próg adaptacyjny — średnia ruchoma 0,5 s</span>
<span class="kw">SELECT</span> mlii[0]-900, mwi[0]*5, (mwi[0]-mwi_thr[0]*2)*5
<span class="kw">STREAM</span> qrs_out <span class="kw">FROM</span> mlii+mwi+mwi_thr</pre>
    </div>
  </section>

  <section id="lineage">
    <div class="wrap">
      <span class="sec-eyebrow">Rodowód</span>
      <h2>Stulecie matematyki, jeden silnik</h2>
      <div class="timeline">
        <div class="tl first" tabindex="0">
          <div class="tl-inner">
            <div class="yr">1926</div>
            <p>Beatty pokazuje, że dwa ciągi &lfloor;np&rfloor;, &lfloor;nq&rfloor; dzielą &#8469; dla niewymiernych częstotliwości.</p>
          </div>
        </div>
        <div class="tl" tabindex="0">
          <div class="tl-inner">
            <div class="yr">1969</div>
            <p>Fraenkel uogólnia kryterium podziału na parametry <strong>wymierne</strong> &mdash; <a href="https://planetmath.org/fraenkelspartitiontheorem">przypadek obliczalny</a>.</p>
          </div>
        </div>
        <div class="tl" tabindex="0">
          <div class="tl-inner">
            <div class="yr">2003</div>
            <p>Algebra operatorów i deklaratywny język zapytań zostają zdefiniowane w kontekście monitorowania płodu [JMIT t. 5&ndash;6].</p>
          </div>
        </div>
        <div class="tl" tabindex="0">
          <div class="tl-inner">
            <div class="yr">2006</div>
            <p>Most między systemami pokryć a wyrównywaniem strumieni zostaje ustanowiony w recenzowanej publikacji <a href=
            "https://www.academia.edu/1840564/Deterministic_method_of_data_sequence_processing">Det. method...</a> .</p>
          </div>
        </div>
        <div class="tl" tabindex="0">
          <div class="tl-inner">
            <div class="yr">2026</div>
            <p>Pełna formalna semantyka, dowody i raport z silnika: <a href="https://arxiv.org/abs/2607.07730">arXiv:2607.07730</a>.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

</main>
