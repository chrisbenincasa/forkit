# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.add_new_ingredient').on 'click', (e) ->
    e.preventDefault()
    $(e.currentTarget).parent().append('<input type="text" name="ingredients[]"/>')

  $('.recipe_image_upload').on 'change', (e) ->
    if window.File && window.FileReader && window.FileList
      file = e.target.files[0]
      reader = new FileReader
      reader.readAsDataURL(file)
      reader.onload = (e) ->
        $('.preview_image').attr('src', e.target.result)

  $('.recipe_rating').on 'click', (e) ->
    e.preventDefault()
    rating = $(this).text()
    recipe = $(this).attr 'recipe'
    $.ajax
      url: "http://localhost:2000/recipes/#{recipe}/update_rating",
      data: {rating: rating},
      type: 'POST',
      dataType: 'json',
      success: (result) ->
        $('.rating').html("<b>Rating: </b> #{result.rating}")
        $('.personal_rating').html("<b>Your rating:</b> #{rating}.0")
      error: (error) ->
        console.log error
