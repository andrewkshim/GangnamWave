$ ->

  slantTabSelector = '.slant-tab'
  hiddenSlantTabSelector = "#{slantTabSelector}.hidden"
  slantTabContainerSelector = "#{slantTabSelector}-container"
  slantTabContentSelector = "#{slantTabSelector}-content"
  titleContainerSelector = '#title-container'
  slantDrawerSelector = '#slant-drawer'
  tabContentSelector = '#tab-content'

  unless Modernizr.history
    alert """
      Your browser does not support some
      of the functionality required by this
      website. Please use Chrome or the
      latest version of modern browsers
      such as Safari or Firefox for the 
      best experience.
     """

  pauseVideo = ->
    video = document.getElementById('gangnamVideo')
    $('#veil').addClass('darkened')
    unless video.paused
      video.pause()

  playVideo = ->
    video = document.getElementById('gangnamVideo')
    $('#veil').removeClass('darkened')
    if video.paused
      video.play()

  createTabContentElement = (headerContent) ->
    $('.slant-container.right').append($('<div>', { id: 'tab-content' }))
    $(tabContentSelector).append($('<div>', { class: 'container' }))

  activateTabContentFromTab = (tabElement) ->
    console.log 'from tab'
    playVideo()
    $(tabContentSelector).remove()
    createTabContentElement(tabElement.data('header'))
    setTimeout( ->
      activateTabContentFromHome(tabElement)
    , 700)

  activateTabContentFromHome = (tabElement) ->
    console.log 'from home'
    tabContentElement = $(tabContentSelector)
    tabContentBody = tabContentElement.children('.container')
    tabElement.addClass('active')
    tabContentElement.addClass('active')
    href = tabElement.data('link')
    $.get("/tab/#{href}", (data) ->
      history.pushState({}, 'Introduction', href)
      tabContentBody.html(data)
    )
    setTimeout( ->
      pauseVideo()
    , 700
    )

  hideTabContent = (callback) ->
    tabContentElement = $('#tab-content')
    tabContentElement.removeClass('active')
    $(slantTabSelector).removeClass('active')
    playVideo()
    callback()

  clearSlantTabs = (fromTabCallback, fromHomeCallback) ->
    slantTabs = $(slantTabSelector)
    if slantTabs.hasClass('active')
      playVideo()
      slantTabs.removeClass('active')
      $('#tab-content').addClass('removed')
      setTimeout( ->
        fromTabCallback()
      , 700)
    else
      fromHomeCallback()

  $(slantTabSelector).click( (event) ->
    tabElement = $(this)
    if tabElement.hasClass('active')
      return false
    clearSlantTabs( ->
      activateTabContentFromTab(tabElement)
    , ->
      activateTabContentFromHome(tabElement)
    )
  ).hover( (event) ->
    $(this).addClass('hovered')
  , (event) ->
    $(this).removeClass('hovered')
  )

  hideSlantTabs = ->
    timeElapsed = 200
    $(slantTabSelector).each( (index, element) ->
      setTimeout( ->
        $(element).addClass('hidden')
      , 100 * (index+1))
      timeElapsed += 100
    )
    $('.slant').addClass('home')
    $('#menu-button').addClass('home')
    setTimeout( ->
      $(slantDrawerSelector).addClass('hidden')
    , timeElapsed/2)
    setTimeout( ->
      $(titleContainerSelector).removeClass('hidden')
    , timeElapsed)

  revealHiddenSlantTabs = ->
    $(hiddenSlantTabSelector).each( (index, element) ->
      setTimeout( ->
        $(element).removeClass('hidden')
      , 100 * (index+1))
    )
    $(titleContainerSelector).addClass('hidden')
    $(slantDrawerSelector).removeClass('hidden')
    slantElement = $('.slant')
    slantElement.removeClass('home')
    $('#menu-button').removeClass('home')

  toggleSlantTabs = ->
    if ($(hiddenSlantTabSelector).length)
      revealHiddenSlantTabs()
    else
      hideSlantTabs()

  $('#menu-button').click( (event) ->
    toggleSlantTabs()
    console.log('pressed')
  )

  $('#home-button').click( (event) ->
    if $(tabContentSelector).hasClass('active')
      hideTabContent( ->
        history.pushState({}, 'Gangnam Wave', '/')
      )
  )

  $('#header-title').click( (event) ->
    if $(tabContentSelector).hasClass('active')
      hideTabContent( ->
        setTimeout( ->
          hideSlantTabs()
          history.pushState({}, 'Gangnam Wave', '/')
        , 200)
      )
    else
      hideSlantTabs()
  )

  $(window)
    .focus( (event) ->
      playVideo()
    )
    .blur( (event) ->
      pauseVideo()
    )


