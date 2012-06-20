$(document).ready (e) ->
  page = 1
  loading = false
  #totalPages = Math.ceil(<%= Recipe.count / 8.0 %>)

  $('.turn_recipe a').on 'click', (e) ->
    e.preventDefault()
    if $('.first_page').is ':visible'
      $('.first_page').hide 0, ->
        $('.wrap').removeClass('page').addClass('page_left')
        $('.second_page').show 0
      extraParagraphs = new Array()
      $('.recipe_desc').find('p').each (i,ele)->
        if $(this).position().top > $('.recipe_desc').height()
          extraParagraphs.push(this)
          $(this).remove()
      $('.right_page .second_page').append($(ele)) for ele in extraParagraphs
    else
      $('.second_page').hide 0, ->
        $('.wrap').removeClass('page_left').addClass('page')
        $('.first_page').show()

  $('.turn_page a').click (e) ->
    e.preventDefault()
    if loading
      return
    loading = true
    page++
    $.ajax
      url: '/recipes?page='+page
      type: 'get'
      dataType: 'script'
      success: ->
        console.log 'success'
        loading = false
        #history.pushState {currentPage: page}, '', '/recipes?page='+(page-1)
      error: (xhr, status, code) ->
        console.log status, code, 'why'
