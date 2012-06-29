$(document).ready (e) ->
  page = 1
  $(document).on 'click', '.lightbox', (e) ->
    if e.target == this
      $(this).fadeOut('fast')

  $(document).on 'focus', '.lightbox input', (e) ->
    $(this).siblings('label').hide()

  $(document).on 'blur', '.lightbox input', (e) ->
    if !$(this).val().length > 0
      $(this).siblings('label').show()

  $('#top_ingredients path').on 'click', (e) ->
    slug = $(this).next('text').find('tspan').text().toLowerCase()
    window.location = "../../ingredients/#{slug}"

  $('.recipe_book_page_turn a').on 'click', (e) ->
    e.preventDefault()
    if $(this).parent().hasClass('forward')
      page++
    else
      page--
    $.ajax
      url: '?page='+page
      type: 'get'
      dataType: 'script'
      success: (data) ->
        if data == null
          console.log 'hello'
      error: (xhr, status) ->
        console.log xhr, status

  setTimeout -> 
    $('.flash').slideUp(100)
  , 5000