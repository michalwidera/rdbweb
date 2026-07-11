---
layout: home
permalink: /
title: "RetractorDB"
seo_title: "RetractorDB — Exact streams. Deterministic by theorem."
excerpt: "RetractorDB is an open-source Deterministic Edge Signal Processing Engine whose resampling operators are proved exact — grounded in rational Beatty sequences and Fraenkel's partition theorem."
rich_icons: true
fontawesome: true
og_image: "/assets/images/icon/ms-icon-310x310.png"
og_image_width: 310
og_image_height: 310
---

<header class="home-hero">
  <div class="hero">
    <span class="eyebrow">Open-source Deterministic Edge Signal Processing Engine</span>
    <h1>Exact streams.<br>Deterministic <em>by theorem</em>.</h1>
    <p class="lede">
      RetractorDB merges and resamples regular time series with zero
      approximation error. Its core operators are proved correct over
      rational arithmetic — grounded in Beatty sequences and
      Fraenkel&rsquo;s partition theorem. Replay a recording, get the
      same bits. Every time.
    </p>
    <div class="cta-row">
      <a class="btn btn-primary" href="https://arxiv.org/abs/2607.07730">Read the paper</a>
      <a class="btn btn-ghost" href="https://github.com/michalwidera/retractordb">View on GitHub</a>
    </div>
    <p class="hero-note">arXiv:2607.07730 &nbsp;·&nbsp; MIT license</p>

    {% include home/merge-diagram.html %}
  </div>
</header>

<main class="home">

  <section id="idea">
    <div class="wrap">
      <span class="sec-eyebrow">The idea</span>
      <h2>A merge you can always undo</h2>
      <p class="body">
        Most stream systems stamp every event with a timestamp and
        reconcile things in fuzzy time windows. RetractorDB starts from
        something simpler: a regular stream is just a clock — a starting
        point and a fixed interval between ticks. Two clocks running at
        different rates can be woven into one combined stream, in order,
        with nothing lost.
      </p>
      <p class="body">
        The part that matters: that combined stream can always be pulled
        back apart into the exact two clocks it came from &mdash; no
        approximation, no drift, no guessing which tick came from which
        stream. Merge and split are exact opposites, for any pair of
        regular rates. Replay the same recording twice and get the
        identical result down to the bit, because the operation was
        never approximate to begin with.
      </p>
      <p class="body">
        It's also where the marks come from &mdash; the scissors mark is
        literally this split operation, drawn.
      </p>
      <div class="legend">
        <span class="chip"><span class="dot a"></span> stream A</span>
        <span class="chip"><span class="dot b"></span> stream B</span>
      </div>
      <p class="hero-note" style="margin-top:8px">
        The formal proof &mdash; grounded in number theory &mdash; is in
        <a href="https://arxiv.org/abs/2607.07730">the paper</a>, for the curious.
      </p>
    </div>
  </section>

  <section id="applications">
    <div class="wrap">
      <span class="sec-eyebrow">Where it fits</span>
      <h2>Any machine that streams, any signal that matters</h2>
      <p class="body">
        RetractorDB is domain-neutral. It sits at the edge, next to the
        sensors, and turns raw multi-rate telemetry into exact, reduced,
        replay-stable streams before they reach a historian, a TSDB, or
        the cloud. Wherever signals with different sampling rates must be
        merged, resampled, and audited, the algebra applies unchanged —
        only the coefficients differ.
      </p>
      <div class="carousel">
        <div class="carousel-track">
          {% for app in site.data.applications %}
          <div class="card">
            <h3><i class="fa-solid {{ app.icon }}"></i>{{ app.title }}</h3>
            <p>{{ app.text }}</p>
          </div>
          {% endfor %}
          {% for app in site.data.applications %}
          <div class="card" aria-hidden="true">
            <h3><i class="fa-solid {{ app.icon }}"></i>{{ app.title }}</h3>
            <p>{{ app.text }}</p>
          </div>
          {% endfor %}
        </div>
      </div>
      <p class="body" style="margin-top:26px">
        The same pattern recurs wherever regular telemetry meets an audit
        trail: rail and maritime data recorders, seismic networks,
        structural health monitoring of bridges and buildings,
        environmental sensor grids.
      </p>
    </div>
  </section>

  <section id="engine">
    <div class="wrap">
      <span class="sec-eyebrow">The engine</span>
      <h2>Three binaries, one deterministic pipeline</h2>
      <p class="body">
        Declare source streams and continuous transformations in RQL, a
        declarative query language realizing the algebra. The compiler
        resolves every stream to a rational interval and builds a
        dependency DAG; the runtime schedules slots on a rational
        timeline. Identical input traces produce byte-identical
        artifacts — a property exercised continuously in CI.
      </p>
      <div class="cards">
        <div class="card">
          <h3><span>x</span>retractor</h3>
          <p>Parser, compiler, and runtime for RQL plans. Compile-only and plan-dump modes for inspection.</p>
        </div>
        <div class="card">
          <h3><span>x</span>qry</h3>
          <p>Queries running streams live over IPC — raw or formatted, ready to pipe into gnuplot.</p>
        </div>
        <div class="card">
          <h3><span>x</span>trdb</h3>
          <p>Inspects and edits binary artifacts: schema, null/gap metadata, deterministic test data.</p>
        </div>
      </div>
    </div>
  </section>

  <section id="rql">
    <div class="wrap">
      <span class="sec-eyebrow">RQL in practice</span>
      <h2>One worked example, the same algebra everywhere</h2>
      <p class="body">
        Every domain above reduces to the same operator chain. As the
        paper&rsquo;s worked example we chose a demanding, well-specified
        pipeline from the engine&rsquo;s original domain: the
        Pan&ndash;Tompkins QRS detector over MIT-BIH ECG data —
        bandpass, derivative, squaring, integration, adaptive threshold,
        end-to-end in the algebra. Swap the coefficients and the same
        chain computes a vibration envelope or a bus-signal feature. No
        user-defined functions, no procedural escape hatches.
      </p>
      <pre class="code"><span class="kw">DECLARE</span> MLII INTEGER, V1 INTEGER <span class="kw">STREAM</span> ecg, 1/360 <span class="kw">FILE</span> 'rec205'

<span class="cm"># 1. bandpass 5–15 Hz — 25-tap FIR convolution</span>
<span class="kw">SELECT</span> * <span class="kw">STREAM</span> mlii_win <span class="kw">FROM</span> mlii@(1,25)
<span class="kw">SELECT</span> mlii_win[_]*bpf[_] <span class="kw">STREAM</span> bp_acc <span class="kw">FROM</span> mlii_win+bpf

<span class="cm"># 2. derivative   3. squaring   4. moving-window integration</span>
<span class="kw">SELECT</span> d_out[0]*d_out[0]/1000 <span class="kw">STREAM</span> sq_out <span class="kw">FROM</span> d_out

<span class="cm"># 5. adaptive threshold — 0.5 s moving average</span>
<span class="kw">SELECT</span> mlii[0]-900, mwi[0]*5, (mwi[0]-mwi_thr[0]*2)*5
  <span class="kw">STREAM</span> qrs_out <span class="kw">FROM</span> mlii+mwi+mwi_thr</pre>
    </div>
  </section>

  <section id="lineage">
    <div class="wrap">
      <span class="sec-eyebrow">Lineage</span>
      <h2>A century of mathematics, one engine</h2>
      <div class="timeline">
        <div class="tl first">
          <div class="yr">1926</div>
          <p>Beatty shows two sequences &lfloor;np&rfloor;, &lfloor;nq&rfloor; partition &#8469; for irrational rates.</p>
        </div>
        <div class="tl">
          <div class="yr">1969</div>
          <p>Fraenkel generalizes the partition criterion to <strong>rational</strong> parameters — the computable case.</p>
        </div>
        <div class="tl">
          <div class="yr">2006</div>
          <p>The covering-systems &harr; stream-alignment bridge is established in peer-reviewed form.</p>
        </div>
        <div class="tl">
          <div class="yr">2026</div>
          <p>Full formal semantics, proofs, and the engine report: <a href="https://arxiv.org/abs/2607.07730">arXiv:2607.07730</a>.</p>
        </div>
      </div>
    </div>
  </section>

</main>
