Floorplan = require './floorplan'
{loadFloorPlan} = require './importer'
{Promise} = require 'es6-promise'

handleFileSelect = (event) ->
  loadFloorPlan 'data/' + event.target.files[0].name

init = ->

  stats = new Stats()
  stats.setMode(0)
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.right = '300px'
  stats.domElement.style.top = '0px'
  document.body.appendChild(stats.domElement)
  
  input = document.createElement("input")
  input.type = "file"
  input.id = "files"
  input.name = "files[]"
  input.addEventListener('change', handleFileSelect, false)
  document.body.appendChild input
  output = document.createElement('output')
  output.id = "list"
  document.body.appendChild output
  
  renderer = PIXI.autoDetectRenderer 1024, 1024, null, false, true
  document.body.appendChild renderer.view

  gui = new dat.GUI()
  scene = Floorplan.get()
 
  gui.addColor(scene, 'backgroundColor').onChange (value) ->
    scene.setBackgroundColor value.replace('#', '0x')
  gui.addColor(scene, 'wallColor').onChange (value) ->
    scene.wallContainer.tint = value.replace('#', '0x')
  gui.addColor(scene, 'areaColor').onChange (value) ->
    scene.areaContainer.tint = value.replace('#', '0x')
  gui.addColor(scene, 'assetColor').onChange (value) ->
    scene.tintAssets value

  loadFloorPlan 'data/nuova.xml'
  
  animate = () ->
    stats.begin()
    requestAnimFrame(animate)
    renderer.render(Floorplan.get())
    stats.end()

  requestAnimFrame( animate )

window.onload = ->
  init()

