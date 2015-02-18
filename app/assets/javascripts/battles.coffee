# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

replayBattle = ->
  window.replayPlaying = true
  window.paused = false
  setupUnits()
  window.clearInterval(window.iid)
  $("#battle-log").text("Turn 1")
  window.turn = 0
  window.currentUnit = 0
  window.phase = "target"
  window.iid = window.setInterval(nextTick, 1000)
  
setupUnits = ->
  $("#board").addClass("battle-start")
  $(".tile").html("").removeClass("path").removeClass("current")
  for id, unit of window.BattleLog.participants
    tile = getTile(unit.spawn_point)
    tile.html("<span class='unit-icon team-#{unit.team}-unit'></span>")
    unit.location = unit.spawn_point

pauseReplay = ->
  window.clearInterval(window.iid)
  window.paused = true

continueReplay = ->
  window.paused = false
  window.iid = window.setInterval(nextTick, 1000)

stopReplay = ->
  window.clearInterval(window.iid)
  window.replayPlaying = false
  $("#play-icon").removeClass("glyphicon-pause").addClass("glyphicon-play")

nextTick = ->
  if window.phase == "target"
    displayTarget()
    window.phase = "move"
  else if window.phase == "move"
    displayMove()
    window.phase = "attack"
  else
    displayAttack()
    window.phase = "target"
    window.currentUnit++
    if window.currentUnit == window.BattleLog.battle_log[window.turn].length
      window.currentUnit = 0
      window.turn++
      if window.turn == window.BattleLog.battle_log.length
        stopReplay()
      else
        log "Turn #{window.turn + 1}"

displayTarget = ->
  highlightCurrent()
  target = currentUnitLog().target
  if target?
    currentUnit().target = target
    log "#{currentUnit().name} targetted #{getUnit(target).name}."
    highlightTarget()
  else
    target = currentUnit().target
    if target?
      log "#{currentUnit().name} is still targetting #{getUnit(target).name}."
      highlightTarget()
    else
      log "#{currentUnit().name} cannot find any targets."

displayMove = ->
  path = currentUnitLog().path
  if path.length == 1
    log "#{currentUnit().name} stayed put."
  else
    moveUnit(path[0], path[path.length - 1], currentUnit())
    highlightPath(path)
    log "#{currentUnit().name} moved to #{path[path.length - 1]}."


displayAttack = ->
  target = getUnit(currentUnit().target)
  attack = currentUnitLog().attack
  if attack?
    log "#{currentUnit().name} attacked #{target.name}."
    if attack.hit
      log "Hit for #{attack.damage}!"
      if attack.kill
        log "#{currentUnit().name} killed #{target.name}."
        getTile(target.location).html("<span class='glyphicon glyphicon-remove'></span>")
    else
      log "Missed!"
  else
    log "#{currentUnit().name} is out of range and did not attack #{target.name}."

log = (text) ->
  $("#battle-log").append("\n" + text)
  $("#battle-log").scrollTop($("#battle-log")[0].scrollHeight - $("#battle-log").height())

currentUnitLog = ->
  window.BattleLog.battle_log[window.turn][window.currentUnit]

currentUnit = ->
  getUnit(currentUnitLog().id)

highlightCurrent = ->
  $(".current").removeClass("current")
  $(".target").removeClass("target")
  $(".path").removeClass("path")
  qr = currentUnit().location
  $("#tile-#{qr[0]}-#{qr[1]}").addClass("current")

highlightTarget = ->
  $(".enemy").removeClass("enemy")
  target = currentUnit().target
  #console.log target
  if target?
    qr = getUnit(target).location
    $("#tile-#{qr[0]}-#{qr[1]} span").addClass("enemy")

highlightPath = (path) ->
  for qr in path
    $("#tile-#{qr[0]}-#{qr[1]}").addClass("path")
  qr = currentUnit().location
  $("#tile-#{qr[0]}-#{qr[1]}").removeClass("path").addClass("current")

getUnit = (id) ->
  window.BattleLog.participants[id]

getTile = (qr) ->
  $("#tile-#{qr[0]}-#{qr[1]}")

moveUnit = (source, dest, unit) ->
  tile = getTile(dest)
  tile.html("<span class='unit-icon team-#{unit.team}-unit'></span>")
  getTile(source).html("")
  currentUnit().location = dest

$("#play").click ->
  if window.replayPlaying? && window.replayPlaying
    if window.paused
      $("#play-icon").removeClass("glyphicon-play").addClass("glyphicon-pause")
      continueReplay()
    else
      $("#play-icon").removeClass("glyphicon-pause").addClass("glyphicon-play")
      pauseReplay()
  else
    $("#play-icon").removeClass("glyphicon-play").addClass("glyphicon-pause")
    replayBattle()
  false

