---
layout: single
permalink: /different/
title: "Different Time Series DB"
header:
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/IMG_0758.JPG
  caption: "Photo credit: Tomasz Widera"
excerpt: "RetractorDB is the open source time series database"
toc: true
---
contents of this page is _work in progress_.
Page under construction.

# RetractorDB - a different approach to time series processing.

## Abstract

This page is an actual report describing work on the following problem: How is RetractorDB different from other solutions? First, we try to find out what we understand by "other solutions" and what we will compare. Then this page shows simple examples of time series processing on the identified systems and how they can actually be done in RetractorDB. Then we present tasks that are hard or impossible to write and process in competitors. Then we will try something opposite — write tasks that are hard or impossible to write in RetractorDB and how easily they can be done in other solutions. In the summary section we will show how to connect to other time series database systems and get benefits from different solutions — how to cooperate and get the best of different approaches.


## Introduction

First, we need to find what time series databases are close to our RetractorDB.
In a related paper [Data Series Management: Fulfilling the Need for Big Sequence Analytics][KT-2018] we can find reference to [Db-engines page][DB-RANK] with ranking categories. When we narrow our scope to time series dbms we can find actual time series leaders. This page is updated continuously. Method of so called ‘ranking’ is based on mentions in web – methodology is explained on this page.  There is a significant factor in this ranking score called “include secondary database model”. If we turn this checkbox on, we can see systems where time series processing is a secondary or tertiary functionality, and their main application area is NoSQL tasks rather than time series processing problems.

Based on the db-engines ranking page, I’ve chosen InfluxDB, Prometheus and OpenTSDB. Intentionally skipping Kdb+ due to its strict licensing and closed-source model. Additionally, the Kdb+ license shows that we are not able to make any benchmark or report unless the end user receives express, prior written consent.

* InfluxDB is on open source MIT license.
* Prometheus is on Apache 2.0 license.
* OpenTSDB is on LGPL

These are license-friendly products that can be compared and promoted within the community.

## Time series processing tasks

There are various groups of typical time series processing tasks. The simplest are: show me a histogram of changes or show the average value of an incoming measurement. These are the basics of what we can ask of a typical time series database system.
Things become more complicated when someone asks: how much data do you want to use? If you accidentally touch infinity, you start to doubt what "simple" really means.

First we need to realize that RetractorDB works currently only on __regular__ time series. In case of general Time Series Databases - they support both regular and irregular time series.

### Downsampling

The idea of downsampling with time series databases was well described in one of the [InfluxDB presentations][YT-FL-DOWNSAMPL]. According to [OpenTSDB Documentation][OPENTSDB-DOWNSAMPL], downsampling (or in signal processing, decimation) is the process of reducing the sampling rate, or resolution, of data.

[KT-2018]:http://helios.mi.parisdescartes.fr/~themisp/publications/icde18-sms.pdf
[DB-RANK]:https://db-engines.com/en/ranking/time+series+dbms
[YT-FL-DOWNSAMPL]:https://youtu.be/j3x0TohyGJY
[OPENTSDB-DOWNSAMPL]:http://opentsdb.net/docs/build/html/user_guide/query/downsampling.html
[OPENTSDB-AGREGATORS]:http://opentsdb.net/docs/build/html/user_guide/query/aggregators.html
[PROMETHEUS-AGREGATORS]:https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators
