---
layout: home
permalink: /pl/interlace/
lang: pl
lang_alt: /interlace/
title: "Operator interlace"
excerpt: "Połącz dwa ciągi o dwóch różnych odstępach i zobacz, jak operator interlace scala je w jeden, takt po takcie."
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Wypróbuj sam &nbsp;·&nbsp; Operator interlace</span>
      <h1>Dwa zegary.<br>Jeden strumień, <em>bez strat</em>.</h1>
      <p class="lede">
        Podaj dwa ciągi oraz odstęp między kolejnymi elementami każdego z nich
        (jako liczbę wymierną, np. <code>2/3</code>, lub dziesiętną, np. <code>0.5</code>).
        Operator scala je w jeden połączony ciąg o połączonym odstępie
        &Delta;c = &Delta;1&middot;&Delta;2 / (&Delta;1+&Delta;2).
      </p>

      <div class="panel-card operator-demo" style="width: 100%; max-width: 720px; margin: 0; padding: 32px; border-radius: 14px; box-shadow: var(--shadow); text-align: left">
        <form id="interlaceForm">
          <label for="il-seq-a">Pierwszy ciąg (elementy oddzielone przecinkami)</label>
          <input type="text" id="il-seq-a" placeholder="np. a, b, c, d, e">

          <label for="il-seq-b">Drugi ciąg (elementy oddzielone przecinkami)</label>
          <input type="text" id="il-seq-b" placeholder="np. 1, 2, 3, 4, 5">

          <label for="il-rate-a">Pierwszy odstęp (&Delta;1)</label>
          <input type="text" id="il-rate-a" placeholder="np. 2/3 lub 0.5">

          <label for="il-rate-b">Drugi odstęp (&Delta;2)</label>
          <input type="text" id="il-rate-b" placeholder="np. 1/4 lub 0.25">

          <button type="button" class="btn btn-primary" onclick="rdbInterlace()">Połącz ciągi</button>
        </form>

        <div id="il-result" class="operator-result" hidden>
          <h3>Odstępy</h3>
          <div id="il-summary"></div>
          <h3>Połączony ciąg</h3>
          <div id="il-table"></div>
        </div>
        <div id="il-error" class="operator-error"></div>
      </div>

      <div class="cta-row">
        <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Przeczytaj artykuł</a>
        <a class="btn btn-ghost" href="/pl/sum/">Wypróbuj sum</a>
        <a class="btn btn-ghost" href="/pl/install/">Zainstaluj na Linuksie</a>
      </div>
      <span class="hero-note">&Delta;c = &Delta;1&middot;&Delta;2 / (&Delta;1+&Delta;2) &nbsp;·&nbsp; RQL: <code>FROM core0#core1</code></span>
    </div>
  </section>

  <section id="how">
    <div class="home-in">
      <span class="sec-eyebrow">Jak to działa</span>
      <h2>Scalenie, które zawsze można cofnąć</h2>
      <p class="body">
        Interlace tka dwa regularne strumienie w jeden, w kolejności czasu.
        Połączony strumień tyka częściej niż którekolwiek wejście, bo musi
        pomieścić każdy element obu.
      </p>
      <div class="cards-3">
        <div class="feature">
          <h3>Kompletność</h3>
          <p>Każdy element obu wejść pojawia się w wyniku dokładnie raz, w kolejności, w jakiej jego takt wypada na osi czasu. Nic nie jest gubione ani powtarzane.</p>
        </div>
        <div class="feature">
          <h3>Odwracalność</h3>
          <p>Połączony strumień zawsze da się rozdzielić na dokładnie te dwa zegary, z których powstał. Scalanie i rozdzielanie są operacjami odwrotnymi.</p>
        </div>
        <div class="feature">
          <h3>Dokładność</h3>
          <p>To, które wejście dostarcza dany takt, wyznacza wymierny ciąg Beatty&rsquo;ego; twierdzenie o podziale Fraenkla gwarantuje, że oba zbiory pozycji pokrywają wynik dokładnie, bez nakładania się.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="rql" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">RQL w praktyce</span>
      <h2>Ten sam operator w zapytaniu</h2>
      <p class="body">
        W RQL interlace zapisuje się jako <code>#</code> między dwoma
        strumieniami. Tutaj <code>core0</code> tyka co 1/16, a
        <code>core1</code> co 1/8, więc <code>str3</code> tyka co 1/24.
      </p>
      <div class="code-card code-card-soft">
        <div class="code-bar">
          <span class="tab on">query.rql</span>
          <span class="code-caption">test/IntegrationTest/operations</span>
        </div>
        <div class="code">
          <div><span class="kw">DECLARE</span> a <span class="kw">UINT</span> <span class="kw">STREAM</span> core0, 1/16 <span class="kw">FILE</span> 'datafile1.txt'</div>
          <div><span class="kw">DECLARE</span> a <span class="kw">UINT</span> <span class="kw">STREAM</span> core1, 1/8 <span class="kw">FILE</span> 'datafile2.txt' <span class="kw">ONESHOT</span></div>
          <div class="gap"></div>
          <div><span class="kw">SELECT</span> str3[0] <span class="kw">STREAM</span> str3 <span class="kw">FROM</span> core0#core1</div>
        </div>
      </div>
      <p class="note">
        Formalna definicja i dowód znajdują się w <a href="https://arxiv.org/abs/2607.07730">artykule</a>.
        Algebra operatorów jest streszczona na <a href="/pl/">stronie głównej</a>.
      </p>
    </div>
  </section>

</main>

<script>
(function(){
  function parseRational(str){
    str = str.trim();
    if (str.includes('/')) {
      var parts = str.split('/');
      if (parts.length !== 2) throw new Error('Nieprawidłowy odstęp: ' + str);
      var num = parseFloat(parts[0]), den = parseFloat(parts[1]);
      if (isNaN(num) || isNaN(den) || den === 0) throw new Error('Nieprawidłowy odstęp: ' + str);
      return num / den;
    }
    var n = parseFloat(str);
    if (isNaN(n)) throw new Error('Nieprawidłowy odstęp: ' + str);
    return n;
  }
  function parseSequence(str, label){
    var items = str.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s !== ''; });
    if (items.length === 0) throw new Error(label + ' ciąg nie może być pusty');
    return items;
  }
  window.rdbInterlace = function(){
    var errorEl = document.getElementById('il-error');
    var resultEl = document.getElementById('il-result');
    errorEl.textContent = '';
    try {
      var A = parseSequence(document.getElementById('il-seq-a').value, 'Pierwszy');
      var B = parseSequence(document.getElementById('il-seq-b').value, 'Drugi');
      var r1 = parseRational(document.getElementById('il-rate-a').value);
      var r2 = parseRational(document.getElementById('il-rate-b').value);
      var r3 = (r1 * r2) / (r1 + r2);
      // waga wyboru (udział B w scaleniu), inna niż połączony odstęp
      // wyjściowy r3 - patrz dokumentacja implementacji
      var delta = r2 / (r1 + r2);

      var combined = [];
      var i = 0;
      while (true) {
        var seq1 = Math.floor((i + 1) * delta);
        var seq = Math.floor(i * delta);
        if (seq === seq1) {
          if (i - seq1 >= B.length) break;
          combined.push(B[i - seq1]);
        } else {
          if (seq >= A.length) break;
          combined.push(A[seq]);
        }
        i++;
      }

      document.getElementById('il-summary').innerHTML =
        '<p>&Delta;1 = ' + r1 + ' &middot; &Delta;2 = ' + r2 + ' &middot; &Delta;c = ' + r3 + '</p>';
      document.getElementById('il-table').innerHTML =
        '<table><tr><th>Indeks</th><th>Połączony</th></tr>' +
        combined.map(function(item, idx){ return '<tr><td>' + idx + '</td><td><strong>' + item + '</strong></td></tr>'; }).join('') +
        '</table>';
      resultEl.hidden = false;
    } catch (e) {
      resultEl.hidden = true;
      errorEl.textContent = e.message;
    }
  };
})();
</script>
