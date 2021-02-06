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

let Map = {
  init(runId) {
    this.runId = runId;

    this.map = this.initializeMap(() => {
      this.upsertSource();
      this.addLayers();
    });

    this.markers = [];

    return this;
  },

  initializeMap(onLoad) {
    mapboxgl.accessToken = 'pk.eyJ1IjoibWlsbGxsbGx6IiwiYSI6ImNrazBkbjd6cjBnYTQydnBmbnNhOXB2NWIifQ.-nb92XoCw7zjc2ToVmssrQ';

    return new mapboxgl.Map({
      container: 'map',
      // style: 'mapbox://styles/mapbox/streets-v11',
      style: 'mapbox://styles/mapbox/dark-v9',
      center: [-73.98964547170478, 40.73259737898789],
      zoom: 5
    }).on('load', onLoad);
  },

  upsertSource() {
    const sourceId = 'route';
    const data = `/api/runs/${this.runId}/fetch_features.geojson`;

    if (!this.map.loaded()) return false;

    if (this.map.getSource(sourceId)) {
      this.map.getSource(sourceId).setData(`/api/runs/${this.runId}/fetch_features.geojson`);
    } else {
      this.map.addSource(sourceId, {'type': 'geojson', data});
    }

    this.fitBounds();
    this.addMarkers();
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
        'line-color': 'rgb(0, 122, 255)',
        'line-opacity': 0.5,
        'line-width': 6
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
  },

  fitBounds() {
    const url = `/api/runs/${this.runId}/fetch_bounds.json`;

    fetch(url).then(response => response.json())
              .then(data => {
                if (data) {
                  this.map.fitBounds(data, {padding: 100});
                }
              });
  },

  addMarkers() {
    const url = `/api/runs/${this.runId}/fetch_markers.geojson`;

    fetch(url).then(response => response.json())
              .then(geojson => {
                this.clearMarkers();

                geojson.features.forEach((marker) => {

                  // create a HTML element for each feature
                  let el = document.createElement('div');
                  const diff = marker.properties.outbound_dogs - marker.properties.inbound_dogs;
                  el.innerHTML = diff == 0 ? '' : Math.abs(diff);
                  el.className = 'marker';

                  if (diff > 0) el.className += " marker--pick-up";
                  if (diff < 0) el.className += " marker--drop-off";
                  if (diff == 0) el.className += " marker--neutral";

                  // make a marker for each feature and add to the map
                  const markerElement = new mapboxgl.Marker(el)
                    .setLngLat(marker.geometry.coordinates)
                    .addTo(this.map);

                  this.markers.push(markerElement);
                });
              });
  },

  clearMarkers() {
    this.markers.forEach(marker => {
      marker.remove();
    });
  }
};

Hooks.Leg = {
  mounted() {
    this.upsertSource();
  },

  destroyed() {
    this.upsertSource();
  },

  upsertSource() {
    window.Map.upsertSource();
  }
};

Hooks.Point = {
  mounted() {
    this.el.addEventListener('dragstart', this.dragstart.bind(this));
    this.el.addEventListener('dragover', this.dragover.bind(this));
    this.el.addEventListener('dragenter', this.dragenter.bind(this));
    this.el.addEventListener('dragleave', this.dragleave.bind(this));
    this.el.addEventListener('drop', this.drop.bind(this));
  },

  dragstart(event) {
    event.dataTransfer.setData('id', event.target.id);
    console.log('dragstart', event.target.id);
    event.dataTransfer.effectAllowed = 'copy';
  },

  dragover(event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'copy'
  },

  dragenter(event) {
    event.preventDefault();
    event.target.classList.add('enter');
  },

  dragleave(event) {
    event.preventDefault();
    event.target.classList.remove('enter');
  },

  drop(event) {
    event.preventDefault();
    const target = event.target;
    const id = event.dataTransfer.getData('id');
    const element = document.getElementById(id);
    const parent = target.parentElement;
    const sibling = target.nextElementSibling;

    event.target.classList.remove('enter');

    this.pushEvent(element, target);
    parent.insertBefore(element, sibling);
  },

  pushEvent(element, insertAfter) {
    console.log('id', element.dataset.id, 'insertAfter.id', insertAfter.dataset.id);
    this.pushEventTo(`#${this.el.id}`, 'insert_after', {
      id: element.dataset.id,
      insert_after_id: insertAfter.dataset.id
    });
  },

  upsertSource() {
    window.Map.upsertSource();
  }
};

Hooks.PointDrop = {
  mounted() {
    // this.el.addEventListener('drop', (e) => {
    //   e.preventDefault();
    //   console.log('drop')
    //   const id = e.dataTransfer.getData('id');
    //   const target = e.target;
    //   const parent = target.parentElement;
    //   const grandParent = parent.parentElement;
    //   const element = document.getElementById(id);

    //   grandParent.insertBefore(element, parent);
    //   console.log(e);
    // });

    // this.el.addEventListener('dragover', (e) => {
    //   e.preventDefault();
    //   e.target.classList.add('enter');
    //   console.log('dragenter', e);
    // });

    // this.el.addEventListener('dragleave', (e) => {
    //   e.preventDefault();
    //   e.target.classList.remove('enter');
    //   // console.log('dragleave');
    // });
  }
};

Hooks.Run = {
  mounted() {
    const runId = this.el.dataset.id

    window.Map = Map.init(runId);
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
