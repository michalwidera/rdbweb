---
layout: home
permalink: /sum/
lang: en
lang_alt: /pl/sum/
title: "Sum operator"
excerpt: "Combine two sequences with two different intervals and watch the sum operator align them at the shorter interval."
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Try it yourself &nbsp;·&nbsp; Sum operator</span>
      <h1>Two clocks.<br>One stream, <em>aligned</em>.</h1>
      <p class="lede">
        Enter two sequences and the interval between consecutive elements of
        each (as a rational number, e.g. <code>2/3</code>, or a decimal, e.g. <code>0.5</code>).
        The operator aligns them at the combined interval
        &Delta;c = min(&Delta;1, &Delta;2), pairing every tick of the faster
        stream with the matching tick of the slower one.
      </p>

      <div class="panel-card operator-demo" style="width: 100%; max-width: 720px; margin: 0; padding: 32px; border-radius: 14px; box-shadow: var(--shadow); text-align: left">
        <form id="sumForm">
          <label for="sm-seq-a">First sequence (comma-separated)</label>
          <input type="text" id="sm-seq-a" placeholder="e.g., a, b, c, d, e">

          <label for="sm-seq-b">Second sequence (comma-separated)</label>
          <input type="text" id="sm-seq-b" placeholder="e.g., 1, 2, 3, 4, 5">

          <label for="sm-rate-a">First interval (&Delta;1)</label>
          <input type="text" id="sm-rate-a" placeholder="e.g., 2/3 or 0.5">

          <label for="sm-rate-b">Second interval (&Delta;2)</label>
          <input type="text" id="sm-rate-b" placeholder="e.g., 1/4 or 0.25">

          <button type="button" class="btn btn-primary" onclick="rdbSum()">Combine sequences</button>
        </form>

        <div id="sm-result" class="operator-result" hidden>
          <h3>Intervals</h3>
          <div id="sm-summary"></div>
          <h3>Combined sequence</h3>
          <div id="sm-table"></div>
        </div>
        <div id="sm-error" class="operator-error"></div>
      </div>

      <div class="cta-row">
        <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Read the paper</a>
        <a class="btn btn-ghost" href="/interlace/">Try interlace</a>
        <a class="btn btn-ghost" href="/install/">Install on Linux</a>
      </div>
      <span class="hero-note">&Delta;c = min(&Delta;1, &Delta;2) &nbsp;·&nbsp; RQL: <code>FROM core0+core1</code></span>
    </div>
  </section>

  <section id="how">
    <div class="home-in">
      <span class="sec-eyebrow">How it works</span>
      <h2>The faster clock sets the pace</h2>
      <p class="body">
        Sum joins two regular streams side by side. The result ticks as often
        as the faster input; each of its ticks carries the current value of
        both inputs.
      </p>
      <div class="cards-3">
        <div class="feature">
          <h3>Faster leads</h3>
          <p>The output interval is the shorter of the two, &Delta;c = min(&Delta;1, &Delta;2). Every element of the faster stream appears exactly once, in order.</p>
        </div>
        <div class="feature">
          <h3>Slower holds</h3>
          <p>The slower stream is read at the matching tick, so its value repeats until its next element arrives &mdash; no interpolation, no guessing.</p>
        </div>
        <div class="feature">
          <h3>Exact</h3>
          <p>The matching tick is an integer floor over rational intervals. For any pair of regular intervals the pairing is the same on every run, down to the bit.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="rql" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">RQL in practice</span>
      <h2>The same operator, in a query</h2>
      <p class="body">
        In RQL, sum is written <code>+</code> between two streams. Here
        <code>core0</code> ticks every 1/10 and <code>core1</code> every 1/5,
        so <code>str1</code> ticks every 1/10.
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
        The formal definition and proof are in <a href="https://arxiv.org/abs/2607.07730">the paper</a>.
        See the full query, plan and output tuples on the <a href="/">home page</a>.
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
      if (parts.length !== 2) throw new Error('Invalid interval: ' + str);
      var num = parseFloat(parts[0]), den = parseFloat(parts[1]);
      if (isNaN(num) || isNaN(den) || den === 0) throw new Error('Invalid interval: ' + str);
      return num / den;
    }
    var n = parseFloat(str);
    if (isNaN(n)) throw new Error('Invalid interval: ' + str);
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
