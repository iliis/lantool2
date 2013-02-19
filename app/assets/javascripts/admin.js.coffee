# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
onDraw = (c, w, h) ->
  c.fillStyle = 'rgba(0,0,0,1)'
  c.fillRect 10,10,200,100
  c.fillRect 212,10,50,100

  #c.font = "10pt 'Open Sans'"
  c.font = "10pt sans"
  c.fillText "hallo welt", 10, 125

  c.fillStyle = 'rgba(255,155,0,0.5)'
  c.fillRect 0,0,10,10
  c.fillRect w-10,h-10,10,10

onResize = (ctx) ->
  ctx.canvas.width        = ctx.canvas.clientWidth
  # maintain 4:3 aspect ratio
  ctx.canvas.height       = ctx.canvas.clientWidth * 3 / 4
  onDraw ctx, ctx.canvas.width, ctx.canvas.height

$ ->
  canvas = document.getElementById 'testcanvas'
  if canvas && canvas.getContext
    ctx = canvas.getContext '2d'
    onResize ctx
    window.addEventListener 'resize', -> onResize ctx
