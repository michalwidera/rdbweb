---
layout: home
permalink: /pl/sum/
lang: pl
lang_alt: /sum/
title: "Operator sum"
excerpt: "Połącz dwa ciągi o dwóch różnych odstępach i zobacz, jak operator sum wyrównuje je do krótszego odstępu."
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Wypróbuj sam &nbsp;·&nbsp; Operator sum</span>
      <h1>Dwa zegary.<br>Jeden strumień, <em>wyrównany</em>.</h1>
      <p class="lede">
        Podaj dwa ciągi oraz odstęp między kolejnymi elementami każdego z nich
        (jako liczbę wymierną, np. <code>2/3</code>, lub dziesiętną, np. <code>0.5</code>).
        Operator wyrównuje je do połączonego odstępu
        &Delta;c = min(&Delta;1, &Delta;2), parując każdy takt szybszego
        strumienia z odpowiadającym mu taktem wolniejszego.
      </p>

      <div class="panel-card operator-demo" style="width: 100%; max-width: 720px; margin: 0; padding: 32px; border-radius: 14px; box-shadow: var(--shadow); text-align: left">
        <form id="sumForm">
          <label for="sm-seq-a">Pierwszy ciąg (elementy oddzielone przecinkami)</label>
          <input type="text" id="sm-seq-a" placeholder="np. a, b, c, d, e">

          <label for="sm-seq-b">Drugi ciąg (elementy oddzielone przecinkami)</label>
          <input type="text" id="sm-seq-b" placeholder="np. 1, 2, 3, 4, 5">

          <label for="sm-rate-a">Pierwszy odstęp (&Delta;1)</label>
          <input type="text" id="sm-rate-a" placeholder="np. 2/3 lub 0.5">

          <label for="sm-rate-b">Drugi odstęp (&Delta;2)</label>
          <input type="text" id="sm-rate-b" placeholder="np. 1/4 lub 0.25">

          <button type="button" class="btn btn-primary" onclick="rdbSum()">Połącz ciągi</button>
        </form>

        <div id="sm-result" class="operator-result" hidden>
          <h3>Odstępy</h3>
          <div id="sm-summary"></div>
          <h3>Połączony ciąg</h3>
          <div id="sm-table"></div>
        </div>
        <div id="sm-error" class="operator-error"></div>
      </div>

      <div class="cta-row">
        <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Przeczytaj artykuł</a>
        <a class="btn btn-ghost" href="/pl/interlace/">Wypróbuj interlace</a>
        <a class="btn btn-ghost" href="/pl/install/">Zainstaluj na Linuksie</a>
      </div>
      <span class="hero-note">&Delta;c = min(&Delta;1, &Delta;2) &nbsp;·&nbsp; RQL: <code>FROM core0+core1</code></span>
    </div>
  </section>

  <section id="how">
    <div class="home-in">
      <span class="sec-eyebrow">Jak to działa</span>
      <h2>Tempo nadaje szybszy zegar</h2>
      <p class="body">
        Sum zestawia dwa regularne strumienie obok siebie. Wynik tyka tak
        często jak szybsze wejście; każdy jego takt niesie bieżącą wartość
        obu wejść.
      </p>
      <div class="cards-3">
        <div class="feature">
          <h3>Prowadzenie</h3>
          <p>Odstęp wyjściowy jest krótszym z dwóch, &Delta;c = min(&Delta;1, &Delta;2). Każdy element szybszego strumienia pojawia się dokładnie raz, w kolejności.</p>
        </div>
        <div class="feature">
          <h3>Podtrzymanie</h3>
          <p>Wolniejszy strumień jest odczytywany w odpowiadającym takcie, więc jego wartość powtarza się aż do nadejścia kolejnego elementu &mdash; bez interpolacji, bez zgadywania.</p>
        </div>
        <div class="feature">
          <h3>Dokładność</h3>
          <p>Odpowiadający takt to całkowita podłoga z ilorazu wymiernych odstępów. Dla dowolnej pary regularnych odstępów parowanie jest takie samo przy każdym uruchomieniu, co do bitu.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="rql" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">RQL w praktyce</span>
      <h2>Ten sam operator w zapytaniu</h2>
      <p class="body">
        W RQL sum zapisuje się jako <code>+</code> między dwoma strumieniami.
        Tutaj <code>core0</code> tyka co 1/10, a <code>core1</code> co 1/5,
        więc <code>str1</code> tyka co 1/10.
      </p>
      <div class="code-card code-card-soft">
        <div class="code-bar">
          <span class="tab on">query.rql</span>
          <span class="code-caption">test/IntegrationTest/simple</span>
        </div>
        <div class="code">
          <div><span class="kw">STORAGE</span> 'temp'</div>
          <div class="gap"></div>
          <div><span class="kw">DECLARE</span> a <span class="kw">INTEGER</span> <span class="kw">STREAM</span> core0, 0.1 <span class="kw">FILE</span> 'datafile2.dat'</div>
          <div><span class="kw">DECLARE</span> b <span class="kw">INTEGER</span> <span class="kw">STREAM</span> core1, 0.2 <span class="kw">FILE</span> 'datafile3.dat'</div>
          <div class="gap"></div>
          <div><span class="kw">SELECT</span> str1[0]*10,str1[1]*10,str1[1]*str1[0]+20 <span class="kw">STREAM</span> str1 <span class="kw">FROM</span> core0+core1</div>
        </div>
      </div>
      <p class="note">
        Formalna definicja i dowód znajdują się w <a href="https://arxiv.org/abs/2607.07730">artykule</a>.
        Pełne zapytanie, plan i krotki wyjściowe są na <a href="/pl/">stronie głównej</a>.
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
  window.rdbSum = function(){
    var errorEl = document.getElementById('sm-error');
    var resultEl = document.getElementById('sm-result');
    errorEl.textContent = '';
    try {
      var A = parseSequence(document.getElementById('sm-seq-a').value, 'Pierwszy');
      var B = parseSequence(document.getElementById('sm-seq-b').value, 'Drugi');
      var r1 = parseRational(document.getElementById('sm-rate-a').value);
      var r2 = parseRational(document.getElementById('sm-rate-b').value);
      var r3 = Math.min(r1, r2);

      var combined = [];
      var i = 0;
      while (true) {
        var seq1 = Math.floor(i * r1 / r2);
        var seq2 = Math.floor(i * r2 / r1);
        if (r3 === r1) {
          if (seq1 >= B.length) break;
          if (i >= A.length) break;
          combined.push(A[i] + B[seq1]);
        } else {
          if (seq2 >= A.length) break;
          if (i >= B.length) break;
          combined.push(A[seq2] + B[i]);
        }
        i++;
      }

      document.getElementById('sm-summary').innerHTML =
        '<p>&Delta;1 = ' + r1 + ' &middot; &Delta;2 = ' + r2 + ' &middot; &Delta;c = ' + r3 + '</p>';
      document.getElementById('sm-table').innerHTML =
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
