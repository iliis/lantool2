# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
onDraw = (c, w, h) ->
  c.fillStyle = 'rgba(0,0,0,1)'
  c.fillRect 10,10,200,100
  c.fillRect 202,10,250,100

onResize = (ctx) ->
  ctx.canvas.width  = ctx.canvas.clientWidth
  ctx.canvas.height = ctx.canvas.clientHeight
  onDraw ctx, ctx.canvas.width, ctx.canvas.height

$ ->
  canvas = document.getElementById 'testcanvas'
  if canvas.getContext
    ctx = canvas.getContext '2d'
    onResize ctx
    window.addEventListener 'resize', -> onResize ctx
