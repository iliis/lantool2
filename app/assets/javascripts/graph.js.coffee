# graph drawing library

text = (ctx, text, x, y, bold=false) ->
  ctx.font = '14pt Sans'
  ctx.font = 'bold 14pt Sans' if bold
  ctx.textBaseline = 'top'
  ctx.textAlign    = 'left'
  ctx.fillStyle    = 'rgba(0,0,0,1)'
  ctx.fillText text, x, y

@parse_options = (obj) ->
  data = []
  if obj.children.length > 0
    for c in obj.children
      data.push({
        votes: parseInt $(c).attr('votes')
        text:  $(c).attr 'text'
        color: $(c).attr 'color'
      })
  return data

@draw_bar_chart = (ctx, options) ->
  sum = 0
  sum += o.votes for o in options

  if options.length == 0
    text ctx, "Keine Daten verfügbar", 10, 100, true
  else
    x = 0
    for o in options
      if o.votes > 0
        percent = Math.round ( 100 * o.votes / sum )
        w = o.votes / sum * ctx.canvas.width

        ctx.fillStyle = o.color
        ctx.fillRect x+1, 0, w-2, ctx.canvas.height

        ctx.textBaseline = 'bottom'
        ctx.font = 'normal 10pt Sans'
        ctx.fillStyle = 'rgba(0,0,0,1)'
        ctx.fillText percent+"%", x+10, ctx.canvas.height-10

        ctx.font = 'bold 14pt Sans'
        ctx.fillText o.text,      x+10, ctx.canvas.height-20-5
        x += w
