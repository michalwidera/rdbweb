---
layout: default
permalink: /sum/
title: "Sum operator"
eyebrow: "Try it yourself"
excerpt: "Combine two sequences at two different rates and watch the sum operator align them at the faster rate."
---

Enter two sequences and the rate each one arrives at (as a rational
number, e.g. `2/3`, or a decimal, e.g. `0.5`). The operator aligns them
at the combined rate &Delta;c = min(&Delta;1, &Delta;2), pairing every
tick of the faster stream with the matching tick of the slower one.

<div class="panel-card operator-demo">
  <form id="sumForm">
    <label for="sm-seq-a">First sequence (comma-separated)</label>
    <input type="text" id="sm-seq-a" placeholder="e.g., a, b, c, d, e">

    <label for="sm-seq-b">Second sequence (comma-separated)</label>
    <input type="text" id="sm-seq-b" placeholder="e.g., 1, 2, 3, 4, 5">

    <label for="sm-rate-a">First rate (&Delta;1)</label>
    <input type="text" id="sm-rate-a" placeholder="e.g., 2/3 or 0.5">

    <label for="sm-rate-b">Second rate (&Delta;2)</label>
    <input type="text" id="sm-rate-b" placeholder="e.g., 1/4 or 0.25">

    <button type="button" class="btn btn-primary" onclick="rdbSum()">Combine sequences</button>
  </form>

  <div id="sm-result" class="operator-result" hidden>
    <h3>Rates</h3>
    <div id="sm-summary"></div>
    <h3>Combined sequence</h3>
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
  window.rdbSum = function(){
    var errorEl = document.getElementById('sm-error');
    var resultEl = document.getElementById('sm-result');
    errorEl.textContent = '';
    try {
      var A = parseSequence(document.getElementById('sm-seq-a').value, 'First');
      var B = parseSequence(document.getElementById('sm-seq-b').value, 'Second');
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
