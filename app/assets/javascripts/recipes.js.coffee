# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# General Recipe Scripts go here:

#= require recipes_scroll
#= require recipe_rating

$(document).ready (e) ->
  $('div.bookmark').hover ->
    $(this).toggleClass('hovered')
    if $(this).hasClass('forked')
      tooltip = $ JST['bookmark_tooltip']({forked: true})
    else
      tooltip = $ JST['bookmark_tooltip']({forked: false})
    $(this).append(tooltip)
  , ->
    if $(this).hasClass('hovered')
      $(this).toggleClass('hovered')
      $(this).find('div.tooltip').remove()

  $('div.bookmark').on 'click', (e) ->
    $('div.tooltip').hide()

  $('.forkit_link').on 'ajax:success', (xhr, data, type) ->
    $(this).parent().toggleClass('forked').toggleClass('hovered')

  $('.forkit_link').on 'ajax:error', (xhr, status, error) ->
    console.log xhr, status, error

  if !!('placeholder' in document.createElement('input') && 
        'placeholder' in document.createElement('textarea'))
    $('input').each ->
      $this = $(this)
      if $this.val() == '' && $this.attr('placeholder') != ''
        $this.val $this.attr('placeholder')
        $this.css('color', '#a9a9a9')
        $this.focus ->
          if $this.val() == $this.attr('placeholder')
            $this.val('')
            $this.css('color', '#000')
        $this.blur ->
          if $this.val() == ''
            $this.val($this.attr('placeholder'))
            $this.css('color', '#a9a9a9')

  $('a.sorter').on 'click', (e) ->
    $(this).addClass('active')

  $(document).on 'mouseenter', '.has_overlay', (e) ->
    $(this).find('.overlay').stop(true, true).fadeIn('fast')

  $(document).on 'mouseleave', '.has_overlay', (e) ->
    $(this).find('.overlay').stop(true).fadeOut('fast')