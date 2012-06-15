$(document).ready (e) ->
  page = 1
  loading = false
  #lastPage = false
  nearBottomOfPage = ->
    $(window).scrollTop() > $(document).height() - $(window).height() - 200

  $(window).on 'scroll', (e) ->
    if loading
      return
    #if lastPage
    #  return
    if nearBottomOfPage()
      loading = true
      page++
      $.ajax
        url: "?page=#{page}"
        type: 'get'
        dataType: 'script'
        success: (data) ->
          loading = false