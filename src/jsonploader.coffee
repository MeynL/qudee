
window['receive_asset'] = (asset) ->

Floorplan = require './floorplan'
{maskFlip} = require './utils'
{Promise} = require 'es6-promise'


module.exports.loadJSONPAssets = (urlArray) ->
  sequence = Promise.resolve()
  urlArray.forEach (url) ->
    sequence = sequence.then ->
      return getJSONP url
    .then (val) ->
      return createImage val, 'under', url+'.under'
    .then (val) -> 
      return createShape val, url+'.color'
    .then (val) ->
      return createImage val, 'over', url+'.over'


getJSONP = (url) ->
  new Promise (resolve, reject) ->
    $.ajax
      url: url
      dataType: 'jsonp'
      jsonpCallback: 'receive_asset'
      jsonp: 'callback'
      error: (data) -> reject data
      success: (data) -> resolve data

createImage = (jsonp, layer, id) ->
  #layer is one of ['under','color','over']
  new Promise (resolve, reject) ->
    if jsonp[layer]
      imageBuilder(id, resolve(jsonp), reject(jsonp), jsonp[layer])
    else
      resolve(jsonp)

createShape = (jsonp, url) ->
  # A shape is created by maskFlipping an image (the fp 'color' layer) 
  new Promise (resolve, reject) ->
    if jsonp['color']
      imageBuilder(url+'.shape', resolve(jsonp), reject(jsonp), maskFlip jsonp['color'])
    else
      resolve(jsonp)

imageBuilder = (id, resolve, reject, src) ->
  if PIXI.TextureCache[id]
    console.log "#{id} is already in TextureCache"
    resolve #don't need same image twice
  
  image = addImageToCache(id)
  image.onload = -> resolve
  image.onerror = -> reject
  image.src = src


addImageToCache = (id) ->
  image = new Image()
  baseTexture = new PIXI.BaseTexture image
  texture = new PIXI.Texture baseTexture
  PIXI.Texture.addTextureToCache texture,id
  image





