//= require jquery.timeago.js
//= require jquery.timeago.de.js
//= require jquery.sortable.min.js
//= require graph.js
//= require highcharts.js

jQuery.timeago.settings.allowFuture = true
jQuery.timeago.settings.refreshMillis = 30000

$ ->
  $('.countdown').each (i, obj) ->
    timestamp = $(obj).attr 'timestamp'
    d   = new Date
    now = new Date
    d.setTime timestamp*1000

    if d>now
      $(obj).timeago()
    else
      $(obj).html 'abgelaufen'

# preference ordering vote functions
# elements are rearrangable via drag-and-drop and their order is then submitted as one string "40,37,38,39"
$ ->
  $('.prefordering').sortable()
  $('form.edit_preference_ordering_poll').submit ->
    opts = $(this).find(".prefordering_option")
    # merge all vote IDs into one comma separated string
    optsstr = ($(o).attr("for") for o in opts).join(",")
    $(this).append('<input type="hidden" name="vote" value="' + optsstr + '" />')

$ ->
  $('.pie_chart').each (i, obj) ->
    data = parse_options(obj)
    data = (d for d in data when d.votes > 0) # filter data so options without votes don't clutter graph
    new Highcharts.Chart({
      chart:
        renderTo: obj
        type: 'pie'
      series: [{data: data}]
      credits:
        enabled: false
      title:
        text: null
      tooltip:
        enabled: false
      plotOptions:
        pie:
          dataLabels:
            enabled: true
            style:
              fontSize: '12pt'
            formatter:
              -> '<b>' + this.point.name + '</b>: ' + this.y
    })



###
$ ->
  $('.poll_canvas').each (i, obj) ->
    if obj.getContext
      ctx = obj.getContext '2d'
      onResize ctx
      window.addEventListener 'resize', -> onResize ctx

onResize = (ctx) ->
  ctx.canvas.width        = ctx.canvas.clientWidth
  # maintain 4:3 aspect ratio
  ctx.canvas.height       = ctx.canvas.clientHeight #Width * 3 / 4
  onDraw ctx

onDraw = (ctx) ->
  draw_bar_chart ctx, parse_options ctx.canvas

###
