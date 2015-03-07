# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

replayBattle = ->
  window.replayPlaying = true
  window.replaySpeed ?= 1000
  window.paused = false
  setupUnits()
  window.clearInterval(window.iid)
  $("#battle-log").text("Turn 1")
  window.turn = 0
  window.currentUnit = 0
  window.phase = "target"
  window.iid = window.setInterval(nextTick, window.replaySpeed)
  
setupUnits = ->
  $("#board").addClass("battle-start")
  $(".tile").html("").removeClass("path current enemy").removeData("unitId")
  clearUnitInfoBoxes()
  for id, unit of window.BattleLog.participants
    unit.currentHP = unit.hp
    tile = getTile(unit.spawn_point)
    putUnitOnTile(unit, tile)
    unit.id = id
    unit.location = unit.spawn_point

pauseReplay = ->
  window.clearInterval(window.iid)
  window.paused = true

continueReplay = ->
  window.paused = false
  window.iid = window.setInterval(nextTick, window.replaySpeed)

stopReplay = ->
  log "Battle ends"
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
  highlightCurrent()
  highlightTarget()
  target = getUnit(currentUnit().target)
  attack = currentUnitLog().attack
  if attack?
    if attack.new_target?
      new_target = getUnit(attack.new_target)
      log "#{currentUnit().name} is too far from #{target.name}. Attacking #{new_target.name} instead."
      target = new_target
      currentUnit().target = attack.new_target
      highlightTarget()
    else
      log "#{currentUnit().name} attacked #{target.name}."
    if attack.hit
      log "Hit for #{attack.damage}!"
      target.currentHP -= attack.damage
      target.currentHP = 0 if target.hp < 0
      highlightHit()
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
  $(".enemy").removeClass("enemy")
  $(".hit").removeClass("hit")
  unit = currentUnit()
  qr = unit.location
  $("#tile-#{qr[0]}-#{qr[1]}").addClass("current")

  updateUnitInfoBox(unit, true)

highlightTarget = ->
  $(".enemy").removeClass("enemy")
  target = currentUnit().target
  if target?
    unit = getUnit(target)
    qr = unit.location
    $("#tile-#{qr[0]}-#{qr[1]}").addClass("enemy")
    updateUnitInfoBox(unit, false)

highlightHit = ->
  unit = getUnit(currentUnit().target)
  qr = unit.location
  $("#tile-#{qr[0]}-#{qr[1]}").addClass("hit")
  width = unit.currentHP / unit.hp * 100
  width = 0 if width < 0
  $("#tile-#{qr[0]}-#{qr[1]} div.hp-box div").attr("style", "width:#{width}%")
  updateUnitInfoBox(unit, false)

updateUnitInfoBox = (unit, isCurrent) ->
  id = if isCurrent then "#selected-unit" else "#targeted-unit"

  $("#{id} .info-header").html("<p><span class='unit-icon team-#{unit.team}-unit'></span> <span class='unit-name'>#{unit.name}</span></p>")

  $("#{id} .info-hp").html("<div class='progress'><div class='progress-bar progress-bar-success' role='progressbar' style='width: #{unit.currentHP / unit.hp * 100}%'>#{unit.currentHP}</div></div>")
  $("#{id} .other-info").html("")
  $("#{id} .other-info").append("<span class='item-icon item-#{unit.weapon_icon}'></span> ")
  $("#{id} .other-info").append("<span class='item-icon item-#{unit.armor_icon}'></span> ")
  $("#{id} .other-info").append("<span class='item-icon item-#{unit.mobility_icon}'></span> ")
  $("#{id} .other-info").append("&nbsp; #{unit.move} <span class='fa fa-arrows'></span> #{unit.evade}/#{unit.defense} <span class='fa fa-shield'></span> #{unit.damage}/#{unit.accuracy}/#{unit.range_min}-#{unit.range_max} <span class='fa fa-crosshairs'></span>")

clearUnitInfoBoxes = ->
  for id in ["#selected-unit", "#targeted-unit"]
    $("#{id} .info-header").html("")

    $("#{id} .info-hp").html("")
    $("#{id} .other-info").html("")

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
  putUnitOnTile(unit, tile)
  getTile(source).html("").removeData("unitId")
  currentUnit().location = dest

putUnitOnTile = (unit, tile) ->
  tile.html("<div class='hp-box'><div style='width:100%'></div></div><span class='unit-icon team-#{unit.team}-unit #{unit.icon_class}'></span>")
  tile.data("unitId", unit.id)


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

$(".tile").click( ->
  id = $(this).data("unitId")
  showDetails(id) if id?
)

showDetails = (id) ->
  $(".current").removeClass("current")
  $(".target").removeClass("target")
  $(".path").removeClass("path")
  $(".enemy").removeClass("enemy")
  $(".hit").removeClass("hit")
  unit = getUnit(id)
  qr = unit.location
  $("#tile-#{qr[0]}-#{qr[1]}").addClass("current")

  clearUnitInfoBoxes()
  updateUnitInfoBox(unit, true)
  if unit.target?
    target = getUnit(unit.target)
    qr = target.location
    $("#tile-#{qr[0]}-#{qr[1]}").addClass("enemy")
    updateUnitInfoBox(target, false)
  
