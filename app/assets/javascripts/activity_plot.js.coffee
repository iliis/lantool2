//= require graph.js

parse_all_activities = (obj) ->
  data = []
  if obj.children.length > 0
    for u in obj.children
      data.push({
        name:       $(u).attr('name')
        activities: parse_activity_of_user u
      })
  return data

parse_activity_of_user = (user) ->
  data = []
  if user.children.length > 0
    for a in user.children
      data.push({
        day: 0
        hour: 0
        activity_count: 0
      })
  return data
