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

  pluralize = (count, noun) ->
    if count == 0 or count > 1 or (0 < count % 1 < 1)
      "#{count} #{noun}s"
    else
      "#{count} #{noun}"

  calculateCookTime = (sliderVal, array = false) ->
    MINUTES_IN_DAY = 1440.0
    MINUTES_IN_HOUR = 60.0
    MINUTE_MULTIPLIER = 1
    minutes = Math.round(sliderVal/MINUTE_MULTIPLIER) * MINUTE_MULTIPLIER
    #minutes = sliderVal*MINUTE_MULTIPLIER
    days = 0
    hours = 0
    if 1 < (minutes / MINUTES_IN_DAY)
      days++
      minutes -= MINUTES_IN_DAY
    if 1 < (minutes / MINUTES_IN_HOUR)
      hours = Math.floor(minutes/MINUTES_IN_HOUR)
      if hours == 24
        hours = 0
        days++
        minutes -= MINUTES_IN_DAY
      minutes -= (hours * MINUTES_IN_HOUR)
    if minutes == 60
      hours++
      minutes -= 60
    if array
      [days, hours, minutes]
    else
      "#{pluralize(days, 'day')}, #{pluralize(hours, 'hour')}, #{pluralize(minutes, 'minute')}"

  updateCookTime = (sliderVal) ->
    cook_time = calculateCookTime(sliderVal, true)
    if cook_time[0] == 0 or cook_time[0] > 1
      $('.cook_time_value span.day_label').text('days,')
    else
      $('.cook_time_value span.day_label').text('day,')
    $('.cook_time_value span.days').text(cook_time[0])
    $('.cook_time_value input.hidden_days').val(cook_time[0])
    if cook_time[1] == 0 or cook_time[1] > 1
      $('.cook_time_value span.hour_label').text('hours,')
    else
      $('.cook_time_value span.hour_label').text('hour,')
    $('.cook_time_value span.hours').text(cook_time[1])
    $('.cook_time_value input.hidden_hours').val(cook_time[1])
    $('.cook_time_value span.minutes').text(cook_time[2])
    $('.cook_time_value input.hidden_minutes').val(cook_time[2])

  $('.slider').slider
    min: 0
    max: 750
    step: 5
    create: (e,ui) ->
      cook_time = $(e.target).data().cook_time
      cook_time = cook_time.split(/\D/)
      cook_time = (parseInt(cook_time[0])*1440) + (parseInt(cook_time[1]*60)) + parseInt(cook_time[2])
      $(e.target).slider('option', 'value', cook_time)
      updateCookTime(cook_time)
    slide: (e,ui) ->
      updateCookTime(ui.value)
      console.log ui.value
    change: (e,ui) ->
      updateCookTime(ui.value)


