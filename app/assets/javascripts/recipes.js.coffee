# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# General Recipe Scripts go here:

#= require recipes_scroll
#= require recipe_rating

$(document).ready (e) ->
  $('.forkit_link').on 'ajax:success', (xhr, data, type) ->
    $(this).toggleClass('forked')
    if $(this).is(':contains(Fork it!)')
      $(this).text('Forked!')
    else
      $(this).text('Fork it!')

  $('.forkit_link').on 'ajax:error', (xhr, status, error) ->
    console.log xhr, status, error