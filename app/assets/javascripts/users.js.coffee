# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready (e) ->

  $('.editable').on 'hover', ->
    $(this).toggleClass('edit_hover')

  $('.editable').on 'click', ->
    textarea = '<div><textarea rows="10" cols="60">' + $(this).html() + '</textarea>';
    button = '<div><input type="button" value="SAVE" class="saveButton" /> OR <input type="button" value="CANCEL" class="cancelButton"/></div></div>';
    revert = $(this).html();

    $(this).after(textarea+button).remove()

  saveChanges = (obj, cancel) ->
    if(!cancel)
      console.log 'save'

  $('.saveButton').on 'click', ->
    console.log 'save'
    saveChanges(this, false)

  $('.cancelButton').on 'click', ->
    console.log 'cancel'
    saveChanges(this, revert)

  $('path').on 'click', (e) ->
    clicked = d3.select(this).data()[0]
    slug = clicked.data.name.toLowerCase()
    window.location = "../../ingredients/#{slug}"
