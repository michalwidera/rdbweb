// Homepage interactions: example switch + tabs, "Where it fits" list, qrs_out plot readout.
// Without JS the first panel of each group stays visible.
(function () {
  function setOn(buttons, attr, value) {
    buttons.forEach(function (b) {
      var on = b.getAttribute(attr) === value;
      b.classList.toggle('on', on);
      if (b.hasAttribute('aria-selected')) b.setAttribute('aria-selected', on ? 'true' : 'false');
      if (b.hasAttribute('aria-pressed')) b.setAttribute('aria-pressed', on ? 'true' : 'false');
    });
  }

  document.querySelectorAll('[data-tabs-root]').forEach(function (root) {
    var exButtons = Array.prototype.slice.call(root.querySelectorAll('[data-example]'));
    var tabButtons = Array.prototype.slice.call(root.querySelectorAll('button[data-tab]'));
    var panels = Array.prototype.slice.call(root.querySelectorAll('.code-panel'));
    var caption = root.querySelector('[data-caption]');
    var state = {
      ex: exButtons.length ? exButtons[0].getAttribute('data-example') : null,
      tab: tabButtons[0].getAttribute('data-tab')
    };

    function render() {
      if (state.ex) setOn(exButtons, 'data-example', state.ex);
      setOn(tabButtons, 'data-tab', state.tab);
      panels.forEach(function (p) {
        var show = p.getAttribute('data-tab') === state.tab && (!state.ex || p.getAttribute('data-ex') === state.ex);
        p.hidden = !show;
        if (show && caption) caption.textContent = p.getAttribute('data-caption');
      });
    }

    exButtons.forEach(function (b) {
      b.addEventListener('click', function () { state.ex = b.getAttribute('data-example'); render(); });
    });
    tabButtons.forEach(function (b) {
      b.addEventListener('click', function () { state.tab = b.getAttribute('data-tab'); render(); });
    });
  });

  document.querySelectorAll('[data-uc-root]').forEach(function (root) {
    var buttons = Array.prototype.slice.call(root.querySelectorAll('[data-uc]'));
    var panels = Array.prototype.slice.call(root.querySelectorAll('[data-uc-panel]'));
    buttons.forEach(function (b) {
      b.addEventListener('click', function () {
        var id = b.getAttribute('data-uc');
        setOn(buttons, 'data-uc', id);
        panels.forEach(function (p) { p.hidden = p.getAttribute('data-uc-panel') !== id; });
      });
    });
  });

  document.querySelectorAll('[data-qrs]').forEach(function (root) {
    var svg = root.querySelector('svg.qrs-chart');
    var hit = root.querySelector('.qrs-hit');
    var cursor = root.querySelector('.qrs-cursor');
    var readout = root.querySelector('[data-qrs-readout]');
    var data = JSON.parse(root.querySelector('[data-qrs-data]').textContent);
    var g = JSON.parse(svg.getAttribute('data-geom'));
    var line = cursor.querySelector('line');
    var c0 = cursor.querySelector('.c0');
    var c1 = cursor.querySelector('.c1');
    var pw = g.W - g.L - g.R;

    function y(v, panel, max) { return panel[1] - (panel[1] - panel[0]) * v / max; }

    function show(i) {
      var x = g.L + pw * i / (g.N - 1);
      line.setAttribute('x1', x);
      line.setAttribute('x2', x);
      c0.setAttribute('cx', x);
      c0.setAttribute('cy', y(data[i][0], g.top, g.ekgMax));
      c1.setAttribute('cx', x);
      c1.setAttribute('cy', y(data[i][1], g.bot, g.lowMax));
      cursor.removeAttribute('hidden');
      readout.textContent = 't = ' + (i / 360).toFixed(3) + ' s    [0] ' + data[i][0] + '    [1] ' + data[i][1] + '    [2] ' + data[i][2];
    }

    hit.addEventListener('mousemove', function (e) {
      var box = svg.getBoundingClientRect();
      var vx = (e.clientX - box.left) / box.width * g.W;
      show(Math.max(0, Math.min(g.N - 1, Math.round((vx - g.L) / pw * (g.N - 1)))));
    });
    hit.addEventListener('mouseleave', function () {
      cursor.setAttribute('hidden', '');
      readout.textContent = readout.getAttribute('data-hint');
    });
  });
})();
