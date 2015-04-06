# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

replayRaid = ->
  window.replayPlaying = true
  window.replaySpeed ?= 1000
  window.paused = false
  setupUnits()
  window.clearInterval(window.iid)
  $("#monster-row").html("")
  log "Raid Start"
  window.currentEncounter = 1
  window.currentAction = null
  window.iid = window.setInterval(nextTick, window.replaySpeed)

setupUnits = ->
  $("#party-front-row, #party-back-row").html("")
  for unit, id in window.RaidLog.party
    unit.currentHP = unit.hp
    $("#party-#{if unit.front then "front" else "back"}-row").append("<div id='unit-#{id}' class='unit-container'><div class='hp-box'><div style='width:100%'></div></div><span class='unit-icon team-A-unit #{unit.icon_class}'></span></div>")

setupEncounter = ->
  $("#raid-encounter").text("Encounter #{window.currentEncounter}")
  $("#monster-row").html("")
  for unit, id in window.RaidLog.monsters[window.currentEncounter]
    unit.currentHP = unit.hp
    $("#monster-row").append("<div id='monster-#{id}' class='unit-container monster-#{unit.icon_class}-container'><div class='hp-box'><div style='width:100%'></div></div><span class='monster-icon monster-#{unit.icon_class}'></span></div>")

pauseReplay = ->
  window.clearInterval(window.iid)
  window.paused = true

continueReplay = ->
  window.paused = false
  window.iid = window.setInterval(nextTick, window.replaySpeed)

stopReplay = ->
  
endReplay = ->
  window.clearInterval(window.iid)
  log "Raid ends"
  window.replayPlaying = false
  $("#play-icon").removeClass("glyphicon-pause").addClass("glyphicon-play")

nextTick = ->
  if window.currentAction == null
    log "Encounter #{window.currentEncounter} start"
    setupEncounter()
    window.currentAction = 0
  else
    action = window.RaidLog["raid_log"][window.currentEncounter - 1][window.currentAction]
    if action.action == "move forward"
      displayMoveForward()
    else
      displayAttack(action)
    window.currentAction++
    if window.currentAction >= window.RaidLog["raid_log"][window.currentEncounter - 1].length
      window.currentAction = null
      window.currentEncounter++
      if window.currentEncounter > window.RaidLog["raid_log"].length
        endReplay()

displayMoveForward = ->
  $("#party-front-row").html($("#party-back-row").html())
  $("#party-back-row").html("")
  log "No units in front row. Moving all units forward."

log = (text) ->
  $("#raid-log").append("\n" + text)
  $("#raid-log").scrollTop($("#raid-log")[0].scrollHeight - $("#raid-log").height())

displayAttack = (action) ->
  current = currentUnit(action)
  target = targetUnit(action)
  highlightCurrent(action)
  if action.hit
    target.currentHP -= action.damage
    highlightHit(action, target)
    log "#{current.name} attacks #{target.name} and hits for #{action.damage} damage! #{ if target.currentHP <= 0 then "#{target.name} fainted!" else "" }"
  else
    highlightMiss(action)
    log "#{current.name} attacks #{target.name} but misses!"

currentUnit = (action) ->
  if action.monster
    window.RaidLog.monsters[window.currentEncounter][action.id]
  else
    window.RaidLog.party[action.id]

targetUnit = (action) ->
  if action.monster
    window.RaidLog.party[action.target]
  else
    window.RaidLog.monsters[window.currentEncounter][action.target]

highlightCurrent =  (action) ->

highlightMiss =  (action) ->

highlightHit =  (action, target) ->
  width = target.currentHP / target.hp * 100
  width = 0 if width < 0
  $("##{if action.monster then 'unit' else 'monster'}-#{action.target} div.hp-box div").attr("style", "width:#{width}%")
  
$("#load-replay").click ->
  $("#load-replay").hide()
  $(".replay-container").show()
  false

$("#play-raid").click ->
  if window.replayPlaying? && window.replayPlaying
    if window.paused
      $("#play-icon").removeClass("glyphicon-play").addClass("glyphicon-pause")
      continueReplay()
    else
      $("#play-icon").removeClass("glyphicon-pause").addClass("glyphicon-play")
      pauseReplay()
  else
    $("#play-icon").removeClass("glyphicon-play").addClass("glyphicon-pause")
    replayRaid()
  false

$("#slower").click ->
  if window.replayPlaying
    window.replaySpeed *= 2
    window.clearInterval(window.iid)
    window.iid = window.setInterval(nextTick, window.replaySpeed)
  false

$("#faster").click ->
  if window.replayPlaying
    window.replaySpeed /= 2
    window.clearInterval(window.iid)
    window.iid = window.setInterval(nextTick, window.replaySpeed)
  false
