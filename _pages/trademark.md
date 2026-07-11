---
layout: default
permalink: /trademark/
title: "Trademark guidelines"
eyebrow: "Brand"
excerpt: "How to write the RetractorDB word mark, and the meaning behind the scissors device mark."
toc: true
---

Trademarks tell the world the source of a good or service. Protecting
them for an open-source project matters precisely because anyone can
fork the code: limiting use of the RetractorDB trademarks lets users
know they're getting the project's own product, or a variant it has
approved, rather than someone else's modified version under the same
name.

The RetractorDB trademark covers one word mark &mdash; **RetractorDB**
&mdash; protected under exclusive right
[R.332224](https://ewyszukiwarka.pue.uprp.gov.pl/search/pwp-details/Z.509860?lng=en)
from the Polish Patent Office.

## Word mark

RetractorDB is written as one word, no space. **Retractor** starts with
a capital letter; **DB** is always capitals. It is set in **Ubuntu
Italic**. &ldquo;Retractor&rdquo; is black on a light plane, white on a
dark plane. &ldquo;DB&rdquo; is always baby blue, `#6699FF`.

<p class="panel-card" style="font-family:'Ubuntu',sans-serif;font-style:italic;font-size:32px">
  Retractor<span style="color:#6699FF">DB</span>
</p>

```html
<link href="https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;1,300&display=swap" rel="stylesheet">
<i><font face="Ubuntu">Retractor</font><font face="Ubuntu" color="#6699FF">DB</font></i>
```

The word mark is also available as pre-drawn SVG artwork, in the same
two background variants as the device mark below:

<div class="panel-card" style="display:flex;gap:32px;align-items:center;flex-wrap:wrap">
  <img src="{{ '/assets/images/retractordb.svg' | relative_url }}" alt="RetractorDB word mark, light background" width="220" height="35">
  <div style="background:#101114;padding:16px;border-radius:8px">
    <img src="{{ '/assets/images/retractordb-onblack.svg' | relative_url }}" alt="RetractorDB word mark, dark background" width="220" height="35">
  </div>
</div>

<p class="body">
  <a href="{{ '/assets/images/retractordb.svg' | relative_url }}" download>Download the light-background version (.svg)</a>
  &nbsp;&middot;&nbsp;
  <a href="{{ '/assets/images/retractordb-onblack.svg' | relative_url }}" download>Download the dark-background version (.svg)</a>
</p>

## Device mark: the scissors

The primary graphic mark is the **scissors / &ldquo;cut-here&rdquo;**
lockup &mdash; a literal drawing of the **de-interleave operator**: a
dotted, interleaved stream is cut and separates into its two
constituent streams, **A** (black) and **B** (blue, `#6699FF`). It's a
deliberate pun on the project's name &mdash; a retractor, and a mark
that cuts a stream apart.

The mark is distributed as SVG in two ink variants &mdash; black for
light backgrounds, white for dark backgrounds &mdash; so it stays crisp
at any size. The pivot ring is always baby blue, `#6699FF`, in both.

<div class="panel-card" style="display:flex;gap:32px;align-items:center;flex-wrap:wrap">
  <img src="{{ '/assets/images/icon/scissors.svg' | relative_url }}" alt="RetractorDB scissors mark, black ink for light backgrounds" width="120" height="120">
  <div style="background:#101114;padding:16px;border-radius:8px">
    <img src="{{ '/assets/images/icon/scissors-dark.svg' | relative_url }}" alt="RetractorDB scissors mark, white ink for dark backgrounds" width="120" height="120">
  </div>
</div>

<p class="body">
  <a href="{{ '/assets/images/icon/scissors.svg' | relative_url }}" download>Download the black version (.svg)</a>
  &nbsp;&middot;&nbsp;
  <a href="{{ '/assets/images/icon/scissors-dark.svg' | relative_url }}" download>Download the white version (.svg)</a>
</p>

The merged-stream dot order, wherever it's drawn, must be the true 2:3
interleave &mdash; **A A B A B A A B A B** &mdash; matching the
documentation's worked example (&Tau; = {1, 2, a, 3, b, 4, 5, c, 6, d}).
Line weight is 16/512 with round caps, matching the original scissors
drawing.

An earlier bars mark &mdash; five bars encoding the same 2:3 interleave
selection sequence, **A B A A B** &mdash; remains valid heritage
artwork (it's the version already submitted to
[dbdb.io](https://dbdb.io)) but is no longer the primary mark used in
navigation, favicons, or social cards.

## Usage

- Don't recolor the device mark outside black / white / `#6699FF`.
- Don't distort, rotate, or add effects (shadows, gradients, outlines).
- Keep clear space around the mark of at least one mark-width on every side.
- `*-onblack.svg` (word mark) and `*-dark.svg` (device mark) variants
  exist for dark surfaces; don't place the light variant on a dark
  background or vice versa.
