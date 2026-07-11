---
layout: default
permalink: /interlace/
title: "Interlace operator"
eyebrow: "Try it yourself"
excerpt: "Combine two sequences at two different rates and watch the interlace operator merge them into one, tick by tick."
---

Enter two sequences and the rate each one arrives at (as a rational
number, e.g. `2/3`, or a decimal, e.g. `0.5`). The operator interlaces
them into a single combined sequence at the merged rate
&Delta;c = &Delta;1&middot;&Delta;2 / (&Delta;1+&Delta;2) &mdash; the
same rule behind the homepage's <a href="/#idea">merge diagram</a>.

<div class="panel-card operator-demo">
  <form id="interlaceForm">
    <label for="il-seq-a">First sequence (comma-separated)</label>
    <input type="text" id="il-seq-a" placeholder="e.g., a, b, c, d, e">

    <label for="il-seq-b">Second sequence (comma-separated)</label>
    <input type="text" id="il-seq-b" placeholder="e.g., 1, 2, 3, 4, 5">

    <label for="il-rate-a">First rate (&Delta;1)</label>
    <input type="text" id="il-rate-a" placeholder="e.g., 2/3 or 0.5">

    <label for="il-rate-b">Second rate (&Delta;2)</label>
    <input type="text" id="il-rate-b" placeholder="e.g., 1/4 or 0.25">

    <button type="button" class="btn btn-primary" onclick="rdbInterlace()">Combine sequences</button>
  </form>

  <div id="il-result" class="operator-result" hidden>
    <h3>Rates</h3>
    <div id="il-summary"></div>
    <h3>Combined sequence</h3>
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
      if (parts.length !== 2) throw new Error('Invalid rate: ' + str);
      var num = parseFloat(parts[0]), den = parseFloat(parts[1]);
      if (isNaN(num) || isNaN(den) || den === 0) throw new Error('Invalid rate: ' + str);
      return num / den;
    }
    var n = parseFloat(str);
    if (isNaN(n)) throw new Error('Invalid rate: ' + str);
    return n;
  }
  function parseSequence(str, label){
    var items = str.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s !== ''; });
    if (items.length === 0) throw new Error(label + ' sequence cannot be empty');
    return items;
  }
  window.rdbInterlace = function(){
    var errorEl = document.getElementById('il-error');
    var resultEl = document.getElementById('il-result');
    errorEl.textContent = '';
    try {
      var A = parseSequence(document.getElementById('il-seq-a').value, 'First');
      var B = parseSequence(document.getElementById('il-seq-b').value, 'Second');
      var r1 = parseRational(document.getElementById('il-rate-a').value);
      var r2 = parseRational(document.getElementById('il-rate-b').value);
      var r3 = (r1 * r2) / (r1 + r2);
      // selection weight (share of B in the merge), distinct from the
      // combined output rate r3 — see the implementation docs
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
        '<table><tr><th>Index</th><th>Combined</th></tr>' +
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
