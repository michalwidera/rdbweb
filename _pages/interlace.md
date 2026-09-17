---
layout: home
permalink: /interlace/
lang: en
lang_alt: /pl/interlace/
title: "Interlace operator"
excerpt: "Combine two sequences with two different intervals and watch the interlace operator merge them into one, tick by tick."
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Try it yourself &nbsp;·&nbsp; Interlace operator</span>
      <h1>Two clocks.<br>One stream, <em>nothing lost</em>.</h1>
      <p class="lede">
        Enter two sequences and the interval between consecutive elements of
        each (as a rational number, e.g. <code>2/3</code>, or a decimal, e.g. <code>0.5</code>).
        The operator interlaces them into a single combined sequence at the
        merged interval &Delta;c = &Delta;1&middot;&Delta;2 / (&Delta;1+&Delta;2).
      </p>

      <div class="panel-card operator-demo" style="width: 100%; max-width: 720px; margin: 0; padding: 32px; border-radius: 14px; box-shadow: var(--shadow); text-align: left">
        <form id="interlaceForm">
          <label for="il-seq-a">First sequence (comma-separated)</label>
          <input type="text" id="il-seq-a" placeholder="e.g., a, b, c, d, e">

          <label for="il-seq-b">Second sequence (comma-separated)</label>
          <input type="text" id="il-seq-b" placeholder="e.g., 1, 2, 3, 4, 5">

          <label for="il-rate-a">First interval (&Delta;1)</label>
          <input type="text" id="il-rate-a" placeholder="e.g., 2/3 or 0.5">

          <label for="il-rate-b">Second interval (&Delta;2)</label>
          <input type="text" id="il-rate-b" placeholder="e.g., 1/4 or 0.25">

          <button type="button" class="btn btn-primary" onclick="rdbInterlace()">Combine sequences</button>
        </form>

        <div id="il-result" class="operator-result" hidden>
          <h3>Intervals</h3>
          <div id="il-summary"></div>
          <h3>Combined sequence</h3>
          <div id="il-table"></div>
        </div>
        <div id="il-error" class="operator-error"></div>
      </div>

      <div class="cta-row">
        <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Read the paper</a>
        <a class="btn btn-ghost" href="/sum/">Try sum</a>
        <a class="btn btn-ghost" href="/install/">Install on Linux</a>
      </div>
      <span class="hero-note">&Delta;c = &Delta;1&middot;&Delta;2 / (&Delta;1+&Delta;2) &nbsp;·&nbsp; RQL: <code>FROM core0#core1</code></span>
    </div>
  </section>

  <section id="how">
    <div class="home-in">
      <span class="sec-eyebrow">How it works</span>
      <h2>A merge you can always undo</h2>
      <p class="body">
        Interlace weaves two regular streams into one, in time order. The
        combined stream ticks more often than either input, because it has
        to carry every element of both.
      </p>
      <div class="cards-3">
        <div class="feature">
          <h3>Complete</h3>
          <p>Every element of both inputs appears exactly once in the result, in the order its tick falls on the timeline. Nothing is dropped or repeated.</p>
        </div>
        <div class="feature">
          <h3>Reversible</h3>
          <p>The combined stream always splits back into the exact two clocks it came from. Merge and split are exact opposites.</p>
        </div>
        <div class="feature">
          <h3>Exact</h3>
          <p>Which input supplies each tick follows a rational Beatty sequence; Fraenkel&rsquo;s partition theorem guarantees the two sets of positions cover the output exactly, with no overlap.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="rql" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">RQL in practice</span>
      <h2>The same operator, in a query</h2>
      <p class="body">
        In RQL, interlace is written <code>#</code> between two streams. Here
        <code>core0</code> ticks every 1/16 and <code>core1</code> every 1/8,
        so <code>str3</code> ticks every 1/24.
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
        The formal definition and proof are in <a href="https://arxiv.org/abs/2607.07730">the paper</a>.
        The operator algebra is summarized on the <a href="/">home page</a>.
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
      // combined output interval r3 - see the implementation docs
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
