# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# General Recipe Scripts go here:

#= require recipes_scroll
#= require recipe_rating

$(document).ready (e) ->
  $('div.bookmark').hover ->
    $(this).toggleClass('hovered')
  , ->
    if $(this).hasClass('hovered')
      $(this).toggleClass('hovered')

  $('.forkit_link').on 'ajax:success', (xhr, data, type) ->
    $(this).parent().toggleClass('forked').toggleClass('hovered')

  $('.forkit_link').on 'ajax:error', (xhr, status, error) ->
    console.log xhr, status, error

  $(document).on 'mouseenter', '.has_overlay', (e) ->
    $(this).find('.overlay').stop(true, true).fadeIn('fast')

  $(document).on 'mouseleave', '.has_overlay', (e) ->
    $(this).find('.overlay').stop(true).fadeOut('fast')