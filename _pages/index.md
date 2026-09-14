---
layout: home
permalink: /
lang: en
lang_alt: /pl/
title: "RetractorDB"
seo_title: "RetractorDB — Exact streams. Deterministic by theorem."
excerpt: "RetractorDB is an open-source Deterministic Edge Signal Processing Engine whose resampling operators are proved exact — grounded in rational Beatty sequences and Fraenkel's partition theorem."
og_image: "/assets/images/icon/ms-icon-310x310.png"
og_image_width: 310
og_image_height: 310
---

<main class="home">

  <section class="hero">
    <div class="hero-in">
      <span class="sec-eyebrow">Open-source Deterministic Edge Signal Processing Engine</span>
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
        <a class="btn btn-ghost" href="https://github.com/michalwidera/retractordb">{% include icons/github.svg %}View on GitHub</a>
      </div>
      <span class="hero-note">arXiv:2607.07730 &nbsp;·&nbsp; MIT license</span>

      {% include home/examples.html lang=page.lang %}
    </div>
  </section>

  <section id="idea">
    <div class="home-in">
      <span class="sec-eyebrow">The idea</span>
      <h2>A merge you can always undo</h2>
      <p class="body">
        A regular stream is just a clock — a starting point and a fixed
        interval between ticks. Two clocks running at different rates can be
        woven into one combined stream, in order, with nothing lost.
      </p>
      <div class="cards-3">
        <div class="feature">
          <div class="feature-head">
            <h3>Exact</h3>
            <span class="feature-icon">{% include home/feature-icons.html icon="exact" %}</span>
          </div>
          <p>Core operators are proved correct over rational arithmetic. No floating-point drift, no approximation — for any pair of regular rates.</p>
        </div>
        <div class="feature">
          <div class="feature-head">
            <h3>Reversible</h3>
            <span class="feature-icon">{% include home/feature-icons.html icon="reversible" %}</span>
          </div>
          <p>The combined stream always splits back into the exact two clocks it came from. Merge and split are exact opposites; the scissors mark is that split, drawn.</p>
        </div>
        <div class="feature">
          <div class="feature-head">
            <h3>Replay-stable</h3>
            <span class="feature-icon">{% include home/feature-icons.html icon="replay" %}</span>
          </div>
          <p>Replay the same recording twice and get the identical result down to the bit — a property exercised continuously in CI.</p>
        </div>
      </div>
      <p class="note">
        The formal proof is in <a href="https://arxiv.org/abs/2607.07730">the paper</a>.
        Try the rules yourself with the <a href="/interlace/">interlace</a>
        and <a href="/sum/">sum</a> operators.
      </p>
    </div>
  </section>

  <section id="applications" class="alt">
    <div class="home-in">
      <span class="sec-eyebrow">Where it fits</span>
      <h2>Any machine that streams, any signal that matters</h2>
      <p class="body">
        RetractorDB is domain-neutral. It sits at the edge, next to the
        sensors, and turns raw multi-rate telemetry into exact, reduced,
        replay-stable streams before they reach a historian, a TSDB, or
        the cloud.
      </p>
      {% include home/applications.html lang=page.lang %}
      <p class="note">
        The same pattern recurs wherever regular telemetry meets an audit
        trail: rail and maritime data recorders, seismic networks,
        structural health monitoring of bridges and buildings,
        environmental sensor grids.
      </p>
    </div>
  </section>

  <section id="engine">
    <div class="home-in">
      <span class="sec-eyebrow">The engine</span>
      <h2>Three binaries, one deterministic pipeline</h2>
      <p class="body">
        Declare source streams and continuous transformations in RQL, a
        declarative query language realizing the algebra. The compiler
        resolves every stream to a rational interval and builds a
        dependency DAG; the runtime schedules slots on a rational timeline.
      </p>
      <div class="cards-3">
        <div class="bin">
          <h3><span>x</span>retractor</h3>
          <p>Parser, compiler, and runtime for RQL plans. Compile-only and plan-dump modes for inspection.</p>
        </div>
        <div class="bin">
          <h3><span>x</span>qry</h3>
          <p>Queries running streams live over IPC — raw or formatted, ready to pipe into gnuplot.</p>
        </div>
        <div class="bin">
          <h3><span>x</span>trdb</h3>
          <p>Inspects and edits binary artifacts: schema, null/gap metadata, deterministic test data.</p>
        </div>
      </div>

      <div class="sub-block" id="rql">
        <span class="sec-eyebrow">RQL in practice</span>
        <h2>One worked example, the same algebra everywhere</h2>
        <p class="body">
          The paper&rsquo;s worked example is a longer chain of the same
          operators: the Pan&ndash;Tompkins QRS detector over MIT-BIH ECG
          data, end-to-end in the algebra. Swap the coefficients and the same
          chain computes a vibration envelope or a bus-signal feature. No
          user-defined functions, no procedural escape hatches.
        </p>
        <ol class="steps">
          <li><span>01</span>Bandpass 5–15 Hz</li>
          <li><span>02</span>Derivative</li>
          <li><span>03</span>Squaring</li>
          <li><span>04</span>Moving-window integration</li>
          <li><span>05</span>Adaptive threshold</li>
        </ol>
        {% include home/qrs-example.html lang=page.lang %}
      </div>
    </div>
  </section>

  <section id="lineage">
    <div class="lineage">
      <div class="lineage-head">
        <span class="sec-eyebrow">Lineage</span>
        <h2>A century of mathematics, one engine</h2>
      </div>
      <ol class="tl-list">
        <li>
          <span class="tl-year">1926</span><span class="tl-dot"></span>
          <p>Beatty shows two sequences &lfloor;np&rfloor;, &lfloor;nq&rfloor; partition &#8469; for irrational rates.</p>
        </li>
        <li>
          <span class="tl-year">1969</span><span class="tl-dot"></span>
          <p>Fraenkel generalizes the partition criterion to <strong>rational</strong> parameters — the <a href="https://planetmath.org/fraenkelspartitiontheorem">computable case</a>.</p>
        </li>
        <li>
          <span class="tl-year">2003</span><span class="tl-dot"></span>
          <p>The operator algebra and declarative query language are defined in a fetal-monitoring context [JMIT vol. 5&ndash;6].</p>
        </li>
        <li>
          <span class="tl-year">2006</span><span class="tl-dot"></span>
          <p>The covering-systems &harr; stream-alignment bridge is established in peer-reviewed form [Annales UMCS Informatica vol. 4] &mdash; now on <a href="https://arxiv.org/abs/2607.10444">arXiv:2607.10444</a>.</p>
        </li>
        <li>
          <span class="tl-year">2026</span><span class="tl-dot"></span>
          <p>Full formal semantics, proofs, and the engine report: <a href="https://arxiv.org/abs/2607.07730">arXiv:2607.07730</a>.</p>
        </li>
      </ol>
    </div>
  </section>

</main>
