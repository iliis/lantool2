# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

draw = (c) ->
  c.fillStyle = 'rgba(1,0.4,0,1)'
  c.fillRect 0,0,200,100

$ ->
  canvas = document.getElementById 'testcanvas'
  if canvas.getContext
    c = canvas.getContext '2d'
    draw c
    div = document.getElementById 'testcanvas_div'
    alert canvas.offsetWidth
