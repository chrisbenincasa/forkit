$(document).ready (e) ->
  ingredients = []

  #indexes for dynamically adding inputs for new/edit pages
  ingredientIndex = 1
  editIngredientIndex = $('.edit_ingredients').find('div.ingredient').length

  #get ingredients list
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
    if $(this).parent().hasClass('new_ingredients')
      ingredientBox = $ JST['add_ingredient']({index: ingredientIndex})
      ingredientIndex++
    else if $(this).parent().hasClass('edit_ingredients')
      ingredientBox = $ JST['add_ingredient']({index: editIngredientIndex})
      editIngredientIndex++
    $(this).parent().append(ingredientBox)
    ingredientBox.find('input').autocomplete
      source: ingredients

  $('.recipe_image_upload').on 'change', (e) ->
    if window.File && window.FileReader && window.FileList
      file = e.target.files[0]
      reader = new FileReader
      reader.readAsDataURL(file)
      reader.onload = (e) ->
        $image = $('.detail_pic')
        if $image.length > 0
          $image.attr('src', e.target.result)
        else
          $('.image_field').prepend('<img class="detail_pic" width="300" height="225" />')
          $('.empty_image').remove()
          $('.detail_pic').attr('src', e.target.result)
    true

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