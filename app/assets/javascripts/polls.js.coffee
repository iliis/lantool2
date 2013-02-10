//= require jquery.timeago.js
//= require jquery.timeago.de.js

jQuery.timeago.settings.allowFuture = true
jQuery.timeago.settings.refreshMillis = 30000

$ ->
  $('.countdown').each (i,obj) ->
    timestamp = $(obj).attr 'timestamp'
    d   = new Date
    now = new Date
    d.setTime timestamp*1000

    if d>now
      $(obj).timeago()
    else
      $(obj).html 'abgelaufen'
