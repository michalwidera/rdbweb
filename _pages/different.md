---
layout: default
title: "A different approach to time series"
permalink: /different/
eyebrow: "Where it fits"
excerpt: "How RetractorDB's algebra compares to InfluxDB, Prometheus and OpenTSDB — and where the whole idea of a hobby time-series engine stands today."
toc: true
---

*This page is a work in progress &mdash; a running report, not a
finished comparison.*

## Abstract

How is RetractorDB different from other solutions? First we need to
find what "other solutions" means, then walk through simple processing
tasks on the identified systems and how they're actually done in
RetractorDB. Then tasks that are hard or impossible to write in
competitors &mdash; and, in fairness, the reverse: tasks that are hard
or impossible in RetractorDB but trivial elsewhere. The summary covers
how to connect RetractorDB to other time series systems and get the
benefit of both.

## Introduction

Using the [db-engines time series ranking][DB-RANK] as a starting
point &mdash; and reading it alongside [Data Series Management: Fulfilling
the Need for Big Sequence Analytics][KT-2018] &mdash; I chose **InfluxDB**,
**Prometheus** and **OpenTSDB** as the comparison set. Kdb+ is
intentionally skipped: its license doesn't permit publishing benchmarks
or reports without the vendor's prior written consent.

- InfluxDB &mdash; MIT license
- Prometheus &mdash; Apache 2.0 license
- OpenTSDB &mdash; LGPL

These are license-friendly products that can be compared and discussed
openly within the community.

RetractorDB currently works only on **regular** time series; general
time series databases support both regular and irregular series. That
narrower scope is the trade RetractorDB makes for exactness &mdash; see
[the idea](/idea/) for why that trade is the point, not a limitation.

## Time series processing tasks

The simplest tasks &mdash; a histogram of changes, the average of an
incoming measurement &mdash; are common ground for any time series
database. It gets harder once someone asks how much data you're
willing to touch: get near infinity, and "simple" stops meaning much.

### Downsampling

Downsampling &mdash; decimation, in signal-processing terms &mdash; is
the process of reducing the sampling rate or resolution of data, as
described in [OpenTSDB's documentation][OPENTSDB-DOWNSAMPL] and
[one of InfluxDB's own talks on the subject][YT-FL-DOWNSAMPL]. In
RetractorDB this isn't a special operator bolted onto the query
language &mdash; it's the same interleave/de-interleave algebra used
everywhere else, applied with a different rational ratio.

## Where the hobby-DB field stands

The [Database of Databases][DBDB] tracks new hobby-classified systems
every year, most of them key-value stores, embedded engines, or
AI-assisted rebuilds of familiar models. Very few take on regular,
multi-rate time series as a first-class algebraic object the way
RetractorDB does &mdash; that gap, more than any benchmark number, is
the actual case for a different approach.

[KT-2018]:http://helios.mi.parisdescartes.fr/~themisp/publications/icde18-sms.pdf
[DB-RANK]:https://db-engines.com/en/ranking/time+series+dbms
[DBDB]:https://dbdb.io/browse?project-type=hobby
[YT-FL-DOWNSAMPL]:https://youtu.be/j3x0TohyGJY
[OPENTSDB-DOWNSAMPL]:http://opentsdb.net/docs/build/html/user_guide/query/downsampling.html
[OPENTSDB-AGREGATORS]:http://opentsdb.net/docs/build/html/user_guide/query/aggregators.html
[PROMETHEUS-AGREGATORS]:https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators
