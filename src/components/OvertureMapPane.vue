<script setup lang="ts">
import 'maplibre-gl/dist/maplibre-gl.css'
import { Map, NavigationControl, addProtocol, Popup } from 'maplibre-gl'
import { createClient } from '@supabase/supabase-js'
import { onMounted } from 'vue'
import { noLabels } from 'protomaps-themes-base'

const client = createClient(
  import.meta.env.VITE_PUBLIC_SUPABASE_URL,
  import.meta.env.VITE_PUBLIC_SUPABASE_ANON_KEY
)

function base64ToArrayBuffer(base64) {
  var binaryString = atob(base64)
  var bytes = new Uint8Array(binaryString.length)
  for (var i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i)
  }
  return bytes
}

addProtocol('supabase', async (params, abortController) => {
  const re = new RegExp(/supabase:\/\/(.+)\/(\d+)\/(\d+)\/(\d+)/)
  const result = params.url.match(re)
  const { data, error } = await client.rpc('mvt_place', {
    relation: result[1],
    z: result[2],
    x: result[3],
    y: result[4],
  })
  const encoded = base64ToArrayBuffer(data)
  if (!error) {
    return { data: encoded }
  } else {
    throw new Error(`Tile fetch error:`)
  }
})

function loadDetails(element, id) {
        element.innerHTML = 'loading...'
        client
          .from('places')
          .select(
            `
          websites,
          socials,
          phones,
          addresses,
          source:  sources->0->dataset
        `
          )
          .eq('id', id)
          .single()
          .then(({ data, error }) => {
            if (error) return console.error(error)
            element.parentElement.innerHTML = `<pre>${JSON.stringify(
              data,
              null,
              2
            )}</pre>`
          })
      }

onMounted(() => {
  const map = new Map({
        hash: true,
        center: [-2.842,48.212],
        container: 'map',
        zoom: 7.5,
        style: {
          version: 8,
          glyphs: 'https://cdn.protomaps.com/fonts/pbf/{fontstack}/{range}.pbf',
          sources: {
            supabase: {
              type: 'vector',
              tiles: ['supabase://places/{z}/{x}/{y}'],
              attribution:
                '© <a href="https://overturemaps.org">Overture Maps Foundation</a>',
            },
            protomaps: {
              type: 'vector',
              // Get a Protomaps API key here: https://protomaps.com/dashboard
              // Or self-host Protomaps: https://docs.protomaps.com/pmtiles/cloud-storage
              url: 'https://api.protomaps.com/tiles/v3.json?key=1003762824b9687f',
              attribution:
                'Basemap © <a href="https://openstreetmap.org">OpenStreetMap</a>',
            },
          },
          layers: [
            ...noLabels('protomaps', 'black'),
            {
              id: 'overture-pois',
              type: 'circle',
              source: 'supabase',
              'source-layer': 'places',
              paint: {
                'circle-color': [
                  'case',
                  ['==', ['get', 'main_category'], 'beauty_salon'],
                  '#fb9a99',
                  ['==', ['get', 'main_category'], 'hotel'],
                  '#33a02c',
                  [
                    '==',
                    ['get', 'main_category'],
                    'landmark_and_historical_building',
                  ],
                  '#a6cee3',
                  ['==', ['get', 'main_category'], 'professional_services'],
                  '#fdbf6f',
                  ['==', ['get', 'main_category'], 'shopping'],
                  '#e31a1c',
                  ['==', ['get', 'main_category'], 'restaurant'],
                  '#1f78b4',
                  ['==', ['get', 'main_category'], 'school'],
                  '#ff7f00',
                  ['==', ['get', 'main_category'], 'accommodation'],
                  '#b2df8a',
                  '#cab2d6',
                ],
                'circle-radius': [
                  'interpolate',
                  ['exponential', 2],
                  ['zoom'],
                  0,
                  1,
                  19,
                  8,
                ],
                'circle-stroke-width': [
                  'interpolate',
                  ['exponential', 2],
                  ['zoom'],
                  12,
                  0,
                  14,
                  2,
                ],
                'circle-stroke-color': 'black',
              },
            },
            {
              id: 'overture-pois-text',
              type: 'symbol',
              source: 'supabase',
              'source-layer': 'places',
              layout: {
                'text-field': '{primary_name}',
                'text-font': ['Noto Sans Regular'],
                'text-size': 10,
              },
              paint: {
                'text-color': [
                  'case',
                  ['==', ['get', 'main_category'], 'beauty_salon'],
                  '#fb9a99',
                  ['==', ['get', 'main_category'], 'hotel'],
                  '#33a02c',
                  [
                    '==',
                    ['get', 'main_category'],
                    'landmark_and_historical_building',
                  ],
                  '#a6cee3',
                  ['==', ['get', 'main_category'], 'professional_services'],
                  '#fdbf6f',
                  ['==', ['get', 'main_category'], 'shopping'],
                  '#e31a1c',
                  ['==', ['get', 'main_category'], 'restaurant'],
                  '#1f78b4',
                  ['==', ['get', 'main_category'], 'school'],
                  '#ff7f00',
                  ['==', ['get', 'main_category'], 'accommodation'],
                  '#b2df8a',
                  '#cab2d6',
                ],
                'text-halo-width': 1,
                'text-halo-color': 'black',
              },
            },
          ],
        },
      })

  const popup = new Popup({
    closeButton: true,
    closeOnClick: false,
    maxWidth: 'none',
  })

  map.addControl(
    new NavigationControl({
      visualizePitch: true
    })
  )

  map.on('click', 'overture-pois-text', async (e) => {
        if (e.features.length > 0) {
          const feature = e.features[0]
          console.log(feature)
          popup.setHTML(
            `
                        <table style="font-size:12px">
                            <tr>
                                <td>id:</td>
                                <td>${feature.properties.id}</td>
                            </tr>
                            <tr>
                                <td>name:</td>
                                <td>${feature.properties.primary_name}</td>
                            </tr>
                            <tr>
                                <td>main_category:</td>
                                <td>${feature.properties.main_category}</td>
                            </tr>
                            <tr>
                                <td>details:</td>
                                <td>
                                  <span onclick="loadDetails(this, '${feature.properties.id}')">
                                    load details
                                  </span>
                                </td>
                            </tr>
                        </table>
                        `
          )
          popup.setLngLat(e.lngLat)
          popup.addTo(map)
        }
      })
})
</script>

<template>
  <div id="map"></div>
</template>

<style scoped>
#map {
  height: 100vh;
}
</style>