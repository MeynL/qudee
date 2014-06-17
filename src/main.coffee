Floorplan = require './floorplan'
{loadFloorPlan} = require './importer'
View = require './view'

handleFileSelect = (event) ->
    loadFloorPlan 'data/' + event.target.files[0].name, (plan) ->
        Floorplan.get().buildPlan plan

STAGE = {width:1600, height:1600}

datGuiInit = (gui) ->
          
    background = gui.addFolder 'background'
    background.addColor(scene, 'backgroundColor').onChange (value) ->
        scene.setBackgroundColor value.replace('#', '0x' )

    wall = gui.addFolder 'walls'
    wall.addColor(scene.wallLayer, 'color').onChange (value) ->
        scene.wallLayer.tint = value.replace('#', '0x')

    areas = gui.addFolder 'areas'
    areas.addColor(scene.areaLayer, 'color').onChange (value) ->
        scene.areaLayer.tint = value.replace('#', '0x')

    items = gui.addFolder 'items'
    items.addColor(scene.itemLayer, 'color').onChange (value) ->
        scene.itemLayer.tintItems value  
    

init = ->

    stats = new Stats()
    stats.setMode(0)
    stats.domElement.style.position = 'absolute'
    stats.domElement.style.left = '100px'
    stats.domElement.style.top = '0px'
    document.body.appendChild(stats.domElement)
  
    input = document.createElement("input")
    input.type = "file"
    input.id = "files"
    input.name = "files[]"
    input.style.position = 'absolute'
    input.style.top = '0px'
    input.style.left = '0px'
    input.addEventListener('change', handleFileSelect, false)
    document.body.appendChild input
    output = document.createElement('output')
    output.id = "list"
    document.body.appendChild output
  
    renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight, null, false, false
    document.body.appendChild renderer.view

    window.onresize = ->
        console.log window.innerWidth, window.innerHeight
        renderer.resize window.innerWidth, window.innerHeight
 
    gui = new dat.GUI()
    #datGuiInit(gui)  

    world = Floorplan.get()
    view = constructView()

    loadFloorPlan 'data/echtgroot.xml',(plan) ->
        Floorplan.get().buildPlan plan
        
        view.render(world)
 
    stage = new Stage(view)

    animate = () ->
        stats.begin()
        requestAnimFrame(animate)
        renderer.render(stage)
        stats.end()

    requestAnimFrame(animate)

# will contain one or more views (later)



class Stage extends PIXI.Stage
    constructor: (@view) ->
        super 0xff0000
        @addChild @view

window.onload = ->
    init()

constructView = ->
    view = new View(0, 0, 1, 1)
    view.setSize(window.innerWidth, window.innerHeight)
    view.setCenter(200,100)
    view.interactive = true
    view.hitArea = new PIXI.Rectangle 0, 0, window.innerWidth, window.innerHeight
    mouseIsDown = false
    mouseDownStart = null
    
    view.mouseup = view.touchend = ->
      mouseIsDown = false

    view.mousemove = view.touchmove =  (e) ->
        if mouseIsDown
#            startTime = new Date().getMilliseconds()
            p = e.getLocalPosition(view)
            x =  mouseDownStart.x - p.x
            y =  mouseDownStart.y - p.y
            mouseDownStart.x = p.x
            mouseDownStart.y = p.y
            scale = view.getScale()
            view.move x / scale, y / scale
            view.render(Floorplan.get())
            stopTime = new Date().getMilliseconds()
#            duration = stopTime - startTime
#            console.log duration

    view.mousedown = view.touchstart = (e) ->
        mouseIsDown = true
        mouseDownStart = e.getLocalPosition(view)
        console.log e.getLocalPosition(view)

    view
    
    


