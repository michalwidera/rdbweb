---
layout: default
permalink: /pl/sum/
lang: pl
lang_alt: /sum/
title: "Operator sum"
eyebrow: "Wypróbuj sam"
excerpt: "Połącz dwa ciągi o dwóch różnych częstotliwościach i zobacz, jak operator sum wyrównuje je do szybszej częstotliwości."
---

Podaj dwa ciągi oraz częstotliwość, z jaką każdy z nich napływa (jako
liczbę wymierną, np. `2/3`, lub dziesiętną, np. `0.5`). Operator wyrównuje
je do połączonej częstotliwości &Delta;c = min(&Delta;1, &Delta;2),
parując każdy takt szybszego strumienia z odpowiadającym mu taktem
wolniejszego.

<div class="panel-card operator-demo">
  <form id="sumForm">
    <label for="sm-seq-a">Pierwszy ciąg (elementy oddzielone przecinkami)</label>
    <input type="text" id="sm-seq-a" placeholder="np. a, b, c, d, e">

    <label for="sm-seq-b">Drugi ciąg (elementy oddzielone przecinkami)</label>
    <input type="text" id="sm-seq-b" placeholder="np. 1, 2, 3, 4, 5">

    <label for="sm-rate-a">Pierwsza częstotliwość (&Delta;1)</label>
    <input type="text" id="sm-rate-a" placeholder="np. 2/3 lub 0.5">

    <label for="sm-rate-b">Druga częstotliwość (&Delta;2)</label>
    <input type="text" id="sm-rate-b" placeholder="np. 1/4 lub 0.25">

    <button type="button" class="btn btn-primary" onclick="rdbSum()">Połącz ciągi</button>
  </form>

  <div id="sm-result" class="operator-result" hidden>
    <h3>Częstotliwości</h3>
    <div id="sm-summary"></div>
    <h3>Połączony ciąg</h3>
    <div id="sm-table"></div>
  </div>
  <div id="sm-error" class="operator-error"></div>
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
