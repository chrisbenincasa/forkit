$(document).ready (e) ->
  ingredients = []
  $.ajax
    url: 'http://recipes.dev/ingredients.json'
    type: 'GET'
    dataType: 'json'
    async: false
    success: (result) =>
      for d in result
        ingredients.push d.name

  $('input.ingredients-input').autocomplete
    source: ingredients

  $('a.add_new_ingredient').on 'click', (e) ->
    e.preventDefault()
    ingredientBox = $ JST['add_ingredient']()
    $(this).parent().append(ingredientBox)
    ingredientBox.autocomplete
      source: ingredients

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
      url: "http://recipes.dev/recipes/#{recipe}/update_rating",
      data: {rating: rating},
      type: 'POST',
      dataType: 'json',
      success: (result) ->
        $('.rating').html("<b>Rating: </b> #{result.rating}")
        $('.personal_rating').html("<b>Your rating:</b> #{rating}.0")
      error: (error) ->
        console.log error