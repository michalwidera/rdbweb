---
layout: default
permalink: /pl/interlace/
lang: pl
lang_alt: /interlace/
title: "Operator interlace"
eyebrow: "Wypróbuj sam"
excerpt: "Połącz dwa ciągi o dwóch różnych częstotliwościach i zobacz, jak operator interlace scala je w jeden, takt po takcie."
---

Podaj dwa ciągi oraz częstotliwość, z jaką każdy z nich napływa (jako
liczbę wymierną, np. `2/3`, lub dziesiętną, np. `0.5`). Operator scala je
w jeden połączony ciąg o połączonej częstotliwości
&Delta;c = &Delta;1&middot;&Delta;2 / (&Delta;1+&Delta;2) &mdash; ta sama
reguła stoi za <a href="/pl/#idea">diagramem scalania</a> na stronie głównej.

<div class="panel-card operator-demo">
  <form id="interlaceForm">
    <label for="il-seq-a">Pierwszy ciąg (elementy oddzielone przecinkami)</label>
    <input type="text" id="il-seq-a" placeholder="np. a, b, c, d, e">

    <label for="il-seq-b">Drugi ciąg (elementy oddzielone przecinkami)</label>
    <input type="text" id="il-seq-b" placeholder="np. 1, 2, 3, 4, 5">

    <label for="il-rate-a">Pierwsza częstotliwość (&Delta;1)</label>
    <input type="text" id="il-rate-a" placeholder="np. 2/3 lub 0.5">

    <label for="il-rate-b">Druga częstotliwość (&Delta;2)</label>
    <input type="text" id="il-rate-b" placeholder="np. 1/4 lub 0.25">

    <button type="button" class="btn btn-primary" onclick="rdbInterlace()">Połącz ciągi</button>
  </form>

  <div id="il-result" class="operator-result" hidden>
    <h3>Częstotliwości</h3>
    <div id="il-summary"></div>
    <h3>Połączony ciąg</h3>
    <div id="il-table"></div>
  </div>
  <div id="il-error" class="operator-error"></div>
</div>

<script>
(function(){
  function parseRational(str){
    str = str.trim();
    if (str.includes('/')) {
      var parts = str.split('/');
      if (parts.length !== 2) throw new Error('Nieprawidłowa częstotliwość: ' + str);
      var num = parseFloat(parts[0]), den = parseFloat(parts[1]);
      if (isNaN(num) || isNaN(den) || den === 0) throw new Error('Nieprawidłowa częstotliwość: ' + str);
      return num / den;
    }
    var n = parseFloat(str);
    if (isNaN(n)) throw new Error('Nieprawidłowa częstotliwość: ' + str);
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
      // waga wyboru (udział B w scaleniu), inna niż połączona częstotliwość
      // wyjściowa r3 — patrz dokumentacja implementacji
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
