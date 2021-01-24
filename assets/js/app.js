// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import mapboxgl from 'mapbox-gl';

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {};

Hooks.Leg = {
  mounted() {
    this.el.addEventListener("submit", this.updateSource.bind(this));
  },

  destroyed() {
    this.updateSource();
  },

  updateSource() {
    window.map.getSource('route').setData('/api/legs/fetch_directions.geojson');
  }
};

Hooks.Map = {
  mounted() {
    mapboxgl.accessToken = 'pk.eyJ1IjoibWlsbGxsbGx6IiwiYSI6ImNrazBkbjd6cjBnYTQydnBmbnNhOXB2NWIifQ.-nb92XoCw7zjc2ToVmssrQ';

    this.map = this.initializeMap(() => {
      this.addSource();
      this.addLayers();
    });
  },

  initializeMap(onLoad) {
    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [-73.98964547170478, 40.73259737898789],
      zoom: 5
    }).on('load', onLoad);

    window.map = this.map;

    return this.map;
  },

  addSource() {
    this.map.addSource(`route`, {
      'type': 'geojson',
      'data': '/api/legs/fetch_directions.geojson'
    });
  },

  addLayers() {
    this.map.addLayer({
      'id': `routes`,
      'type': 'line',
      'source': `route`,
      'layout': {
        'line-join': 'round',
        'line-cap': 'round'
      },
      'filter': ['==', '$type', 'LineString'],
      'paint': {
        'line-color': 'green',
        'line-opacity': 0.75,
        'line-width': 8
      }
    });

    this.map.addLayer({
      'id': `stops`,
      'type': 'circle',
      'source': `route`,
      'filter': ['==', '$type', 'Point'],
      'paint': {
        'circle-radius': 6,
        'circle-color': '#B42222'
      },
    });
  }
};

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
