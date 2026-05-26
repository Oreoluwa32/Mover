(function () {
  "use strict";

  var PURPLE = "#6c1be8";
  var ORANGE = "#f5a623";

  function readJSON(id) {
    var el = document.getElementById(id);
    if (!el) return null;
    try { return JSON.parse(el.textContent); } catch (e) { return null; }
  }

  function compact(value) {
    var abs = Math.abs(value);
    if (abs >= 1e9) return (value / 1e9).toFixed(1).replace(/\.0$/, "") + "B";
    if (abs >= 1e6) return (value / 1e6).toFixed(1).replace(/\.0$/, "") + "M";
    if (abs >= 1e3) return (value / 1e3).toFixed(1).replace(/\.0$/, "") + "K";
    return String(value);
  }

  function lineDataset(label, data, color) {
    return {
      label: label, data: data, borderColor: color, backgroundColor: color,
      tension: 0.45, borderWidth: 3, pointRadius: 0, pointHoverRadius: 5, fill: false,
    };
  }

  function baseLineOptions() {
    return {
      responsive: true, maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      interaction: { intersect: false, mode: "index" },
      scales: {
        x: { grid: { display: false }, border: { display: false } },
        y: { ticks: { callback: function (v) { return compact(v); } }, grid: { color: "#eee" }, border: { display: false } },
      },
    };
  }

  var centerTextPlugin = {
    id: "centerText",
    afterDraw: function (chart) {
      if (!chart.config.options.plugins.centerText) return;
      var cfg = chart.config.options.plugins.centerText;
      var ctx = chart.ctx;
      var x = chart.getDatasetMeta(0).data[0] ? chart.getDatasetMeta(0).data[0].x : chart.width / 2;
      var y = chart.getDatasetMeta(0).data[0] ? chart.getDatasetMeta(0).data[0].y : chart.height / 2;
      ctx.save();
      ctx.textAlign = "center"; ctx.textBaseline = "middle";
      ctx.fillStyle = "#8a8a93"; ctx.font = "500 12px Manrope, sans-serif";
      ctx.fillText(cfg.label, x, y - 12);
      ctx.fillStyle = "#1c142a"; ctx.font = "800 22px Manrope, sans-serif";
      ctx.fillText(cfg.value, x, y + 10);
      ctx.restore();
    },
  };

  function initCharts() {
    if (typeof Chart === "undefined") return;
    Chart.register(centerTextPlugin);

    var trips = readJSON("trips-data");
    var tripsEl = document.getElementById("tripsChart");
    if (trips && tripsEl) {
      new Chart(tripsEl, {
        type: "line",
        data: { labels: trips.labels, datasets: [lineDataset("Ride Sharing", trips.ride, PURPLE), lineDataset("Delivery", trips.delivery, ORANGE)] },
        options: baseLineOptions(),
      });
    }

    var routes = readJSON("routes-data");
    var routesEl = document.getElementById("routesChart");
    if (routes && routesEl) {
      new Chart(routesEl, {
        type: "doughnut",
        data: { labels: ["Ride Sharing", "Delivery"], datasets: [{ data: [routes.ride, routes.delivery], backgroundColor: [PURPLE, ORANGE], borderWidth: 0 }] },
        options: {
          responsive: true, maintainAspectRatio: false, cutout: "70%",
          plugins: { legend: { display: false }, centerText: { label: "Total routes", value: compact(routes.total) } },
        },
      });
    }

    var revenue = readJSON("revenue-data");
    var revenueEl = document.getElementById("revenueChart");
    if (revenue && revenueEl) {
      var ctx = revenueEl.getContext("2d");
      var grad = ctx.createLinearGradient(0, 0, 0, 240);
      grad.addColorStop(0, "rgba(108,27,232,0.22)");
      grad.addColorStop(1, "rgba(108,27,232,0)");
      var ds = lineDataset("Total Revenue", revenue.values, PURPLE);
      ds.fill = true; ds.backgroundColor = grad;
      new Chart(revenueEl, { type: "line", data: { labels: revenue.labels, datasets: [ds] }, options: baseLineOptions() });
    }
  }

  // ---- Live tracking ----
  var trackingState = { map: null, markers: [], movers: [], info: null, root: null };

  function moverItem(m) {
    return (
      '<div class="mover" data-name="' + (m.name || "").toLowerCase() + '" data-lat="' + m.lat + '" data-lng="' + m.lng + '">' +
      '<span class="avatar">' + ((m.name || "?").charAt(0).toUpperCase()) + '</span>' +
      '<div class="mover-meta"><span class="mover-name">' + escapeHtml(m.name) + '</span>' +
      '<span class="mover-ref">' + escapeHtml(m.reference) + '</span></div></div>'
    );
  }

  function escapeHtml(s) {
    return String(s == null ? "" : s).replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  function renderList() {
    var list = document.getElementById("moverList");
    if (!list) return;
    var q = (document.getElementById("moverSearch") || {}).value || "";
    q = q.toLowerCase();
    var filtered = trackingState.movers.filter(function (m) { return !q || (m.name || "").toLowerCase().indexOf(q) >= 0; });
    var count = document.getElementById("moverCount");
    if (count) count.textContent = String(trackingState.movers.length);
    list.innerHTML = filtered.length ? filtered.map(moverItem).join("") : '<p class="muted tracking-empty">No live movers right now.</p>';
  }

  function renderMarkers() {
    if (!trackingState.map || typeof google === "undefined") return;
    trackingState.markers.forEach(function (mk) { mk.setMap(null); });
    trackingState.markers = [];
    var bounds = new google.maps.LatLngBounds();
    trackingState.movers.forEach(function (m) {
      var pos = { lat: m.lat, lng: m.lng };
      var marker = new google.maps.Marker({ position: pos, map: trackingState.map, title: m.name });
      marker.addListener("click", function () {
        if (!trackingState.info) trackingState.info = new google.maps.InfoWindow();
        trackingState.info.setContent(
          '<div style="font:500 12px Manrope,sans-serif"><b>' + escapeHtml(m.name) + "</b><br>" +
          escapeHtml(m.email) + "<br>Type: " + escapeHtml(m.type) + "</div>"
        );
        trackingState.info.open(trackingState.map, marker);
      });
      trackingState.markers.push(marker);
      bounds.extend(pos);
    });
    if (trackingState.movers.length) trackingState.map.fitBounds(bounds);
  }

  function poll() {
    var root = trackingState.root;
    if (!root) return;
    fetch(root.getAttribute("data-api"), { credentials: "same-origin" })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        trackingState.movers = data.movers || [];
        renderList();
        renderMarkers();
      })
      .catch(function () {});
  }

  function initTracking(hasMaps) {
    trackingState.root = document.querySelector(".tracking");
    if (!trackingState.root) return;
    if (hasMaps && typeof google !== "undefined") {
      trackingState.map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: 6.5244, lng: 3.3792 }, zoom: 12, disableDefaultUI: true, zoomControl: true,
      });
    }
    var search = document.getElementById("moverSearch");
    if (search) search.addEventListener("input", renderList);
    poll();
    setInterval(poll, 5000);
  }

  window.MovrDashboard = { initCharts: initCharts, initTracking: initTracking };
  window.MovrTrackingInit = function () { initTracking(true); };
})();
