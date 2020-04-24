# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  rerender()

$ ->
  rerender()

rerender = ->
  $.get('api/planes', (response) ->
    template = response.map((plane)->
      planeComponent(plane)
    ).join('')
    
    if isResponseIncludeOnTakeOfPlanes(response)
      setTimeout ->
        rerender()
      , 5000

    $('#main').html(template);

    $('.send-plane').click ->
      updatePlane($(this).parent().data('id'), 'on_take_of')

    $('.back-plane').click ->
      updatePlane($(this).parent().data('id'), 'hangar')
  )

updatePlane = (planeId, status) ->
  $.ajax
    url: 'api/planes/' + planeId,
    data: { plane: { status: status } }
    type: 'PUT',
    success: (response) ->
      rerender()

planeComponent = (plane) ->
  sendButton = switch plane.status
    when 'hangar' then '<div class="btn btn-primary send-plane">Send plane</div>'
    when 'flew_away' then '<div class="btn btn-primary back-plane">Mark as returned to the hangar</div>'
    else ''

  return '<div class="plane" data-id="' + plane.id + '">' +
      '<a href="planes/' + plane.id + '"><div class="title">' + plane.title + '</div></a>' +
      '<div class="status">' + plane.readable_status + '</div>' +
      sendButton +
    '</div>'

isResponseIncludeOnTakeOfPlanes = (response) ->
  response.map((plane)->
    plane.status
  ).includes('on_take_of')