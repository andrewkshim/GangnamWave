$ ->
  slantTabSelector = '.slant-tab'
  hiddenSlantTabSelector = "#{slantTabSelector}.hidden"
  slantTabContainerSelector = "#{slantTabSelector}-container"
  slantTabContentSelector = "#{slantTabSelector}-content"
  titleContainerSelector = '#title-container'
  tabContentSelector = '#tab-content'
  slantSelector = '#slant'

  skroll = skrollr.init()

  setTabContentHeight = ->
    bodyHeight = $('body').height()
    $(tabContentSelector).height(bodyHeight)
      .children('.container').height(bodyHeight)

  setSlantTabHeight = ->
    slantTabHeight = $(slantTabSelector).height()
    $(slantTabSelector).height(slantTabHeight)

  init = ->
    skroll.refresh()
    #setTabContentHeight()
    #setSlantTabHeight()

  init()

  isTabContentActive = ->
    return $(tabContentSelector).hasClass('active')

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
    unless video.paused
      $('#veil').addClass('darkened')
      video.pause()

  playVideo = ->
    video = document.getElementById('gangnamVideo')
    if video.paused
      $('#veil').removeClass('darkened')
      video.play()

  createTabContentElement = ->
    $('.slant-container.right').append($('<div>', {
      id: 'tab-content'
      'data-0': 'background-color:rgb(0,0,0);'
      'data-10p': 'background-color:rgb(255,255,255);'
    }))
    $(tabContentSelector).append($('<div>', {
      class: 'container'
      'data-0': 'color:rgb(255,255,255);'
      'data-10p': 'color:rgb(0,0,0);'
    }))
    skroll.refresh()

  isTabTransitioning = false

  activateTabContentFromTab = (tabElement) ->
    console.log 'from tab'
    playVideo()
    $(tabContentSelector).remove()
    createTabContentElement()
    setTimeout( ->
      activateTabContentFromHome(tabElement)
    , 700)

  activateTabContentFromHome = (tabElement) ->
    console.log 'from home'
    tabContentElement = $(tabContentSelector)
    tabContentBody = tabContentElement.children('.container')
    tabElement.addClass('active', 500, 'linear')
    tabContentElement.addClass('active')
    setTabContentHeight()
    href = tabElement.data('link')
    $.get("/tab/#{href}", (data) ->
      history.pushState({}, 'Introduction', href)
      tabContentBody.html(data)
    )
    setTimeout( ->
      pauseVideo()
      isTabTransitioning = false
    , 700)

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
      slantTabs.removeAttr('style')
      setSlantTabHeight()
      slantTabs.removeClass('active')
        .children(slantTabContentSelector)
        .removeAttr('style')
      $('#tab-content').addClass('removed')
      setTimeout( ->
        fromTabCallback()
      , 700)
    else
      fromHomeCallback()

  $(slantTabSelector).click( (event) ->
    if isTabTransitioning
      return false
    isTabTransitioning = true
    tabElement = $(this)
    if tabElement.hasClass('active')
      return false
    clearSlantTabs( ->
      activateTabContentFromTab(tabElement)
    , ->
      activateTabContentFromHome(tabElement)
    )
  ).hover( (event) ->
    $(this).addClass('hovered', 500, 'linear')
  , (event) ->
    $(this).removeClass('hovered', 500, 'linear')
  )

  hideSlantTabs = ->
    timeElapsed = 200
    $(slantTabSelector).each( (index, element) ->
      setTimeout( ->
        $(element).addClass('hidden')
      , 100 * (index+1))
      timeElapsed += 100
    )
    $(slantSelector).addClass('home')
    $('#menu-button').addClass('home')
    setTimeout( ->
      console.log('hello')
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
    slantElement = $(slantSelector)
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
      unless isTabContentActive()
        playVideo()
    )
    .blur( (event) ->
      pauseVideo()
    )


