$ ->
  slantTabSelector = '.slant-tab'
  hiddenSlantTabSelector = "#{slantTabSelector}.hidden"
  slantTabContainerSelector = "#{slantTabSelector}-container"
  slantTabContentSelector = "#{slantTabSelector}-content"
  titleContainerSelector = '#title-container'
  tabContentSelector = '#tab-content'
  slantSelector = '#slant'

  #skroll = skrollr.init()

  setTabContentHeight = ->
    bodyHeight = $('body').height()
    $(tabContentSelector).height(bodyHeight)
      .children('.container').height(bodyHeight)

  setSlantTabHeight = ->
    slantTabHeight = $(slantTabSelector).height()
    $(slantTabSelector).height(slantTabHeight)

  init = ->
    #setTabContentHeight()
    #setSlantTabHeight()
    console.log 'init'
    #init()

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
    rightSlantContainer = $('.slant-container.right')
    rightSlantContainer.append($('<div>', {
      id: 'tab-content'
      'data-0': 'background-color:rgb(0,0,0);'
      'data-10p': 'background-color:rgb(255,255,255);'
    }))
    tabContentElement = $(tabContentSelector)
    tabContentElement.append($('<div>', {
      class: 'container'
      'data-0': 'color:rgb(255,255,255);'
      'data-10p': 'color:rgb(0,0,0);'
    }))
    return tabContentElement

  isTabTransitioning = false

  activateTabContentFromTab = (tabElement) ->
    console.log 'from tab'
    playVideo()
    setTimeout( ->
      activateTabContentFromHome(tabElement)
    , 700)

  activateTabContentFromHome = (tabElement) ->
    console.log 'from home'
    $(tabContentSelector).remove()
    tabContentElement = createTabContentElement()
    tabContentElement.addClass('active', 700, 'linear')
    tabContentBody = tabContentElement.children('.container')
    #setTabContentHeight()
    href = tabElement.data('link')
    $.get("/tab/#{href}", (data) ->
      history.pushState({}, '', href)
      tabContentBody.html(data)
      setPsyAge()
      listenNinjaHover()
      #$('#veil').addClass('covered')
    )
    setTimeout( ->
      pauseVideo()
      isTabTransitioning = false
      #skroll.refresh()
      location.reload()
    , 700)

  hideTabContent = (callback) ->
    tabContentElement = $('#tab-content')
    tabContentElement.removeClass('active')
    $(slantTabSelector).removeClass('active')
    playVideo()
    callback()

  clearActiveSlantTab = ->
    activeSlantTab = $("#{slantTabSelector}.active")
      .removeClass('active skrollable skrollable-between')
      .removeAttr('style')
      .removeAttr('data-0')
      .removeAttr('data-10p')
      .find(slantTabContentSelector)
      .removeAttr('style')
      .removeAttr('data-0')
      .removeAttr('data-10p')
      .removeClass('skrollable skrollable-between')

  clearSlantTabs = (isFromTabState, fromTabCallback, fromHomeCallback) ->
    slantTabs = $(slantTabSelector)
    if isFromTabState
      playVideo()
      #setSlantTabHeight()
      tabContentElement = $(tabContentSelector)
      #$('#veil').addClass('covered')
      tabContentElement.addClass('removed')
      setTimeout( ->
        window.scrollTo(0,0)
        fromTabCallback()
      , 700)
    else
      fromHomeCallback()

  slantTabClick = ->
    $(slantTabSelector).click( (event) ->
      if isTabTransitioning
        return false
      tabElement = $(this)
      if tabElement.hasClass('active')
        return false
      isFromTabState = $(slantTabSelector).hasClass('active')
      isTabTransitioning = true
      if isFromTabState
        clearActiveSlantTab()
      tabElement
        .attr('data-0', 'background-color:rgb(0,0,0);')
        .attr('data-10p', 'background-color:rgb(255,255,255);')
        .addClass('active')
        .find('.slant-tab-content')
        .attr('data-0', 'color:rgb(255,255,255);')
        .attr('data-10p', 'color:rgb(0,0,0);')
      clearSlantTabs(isFromTabState, ->
        activateTabContentFromTab(tabElement)
      , ->
        activateTabContentFromHome(tabElement)
      )
    )
         #slantTabClick()

  $('a > .slant-tab').hover( (event) ->
    $(this).addClass('hovered', 450, 'linear')
  , (event) ->
    $(this).removeClass('hovered', 450, 'linear')
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
    #$('#menu-button').addClass('home')
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
    #$('#menu-button').removeClass('home')

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

#  $('#header-title').click( (event) ->
    #if $(tabContentSelector).hasClass('active')
      #hideTabContent( ->
        #setTimeout( ->
          #hideSlantTabs()
          #history.pushState({}, 'Gangnam Wave', '/')
        #, 200)
      #)
    #else
      #hideSlantTabs()
  #)

  $(window)
    .focus( (event) ->
      unless isTabContentActive()
        playVideo()
    )
    .blur( (event) ->
      pauseVideo()
      $(slantTabSelector).removeClass('hovered', 450, 'linear')
    )

  $('.slant-container.right').scroll( (event) ->
    #console.log skroll.getScrollTop()
  )

  getPsyAge = ->
    birthday = new Date(77, 11, 31)
    today = new Date()
    age = today.getYear() - birthday.getYear()
    if today.getMonth() < birthday.getMonth()
      age -= 1
    else if today.getMonth() is birthday.getMonth() and today.getDay() < birthday.getDay()
      age -= 1
    return age

  setPsyAge = ->
    if ($('.psy-age').length)
      $('.psy-age').html(getPsyAge())

  setPsyAge()

  isCoincidental = false
  doAnimation = ->
    if isCoincidental
      return
    isCoincidental = true
    setTimeout( ->
      $('.coincidentally').addClass('active')
    , 1000)
    setTimeout( ->
      $('.coincidentally').removeClass('active')
      isCoincidental = false
      $('.ninja-image > .curtain').removeClass('hovered')
    , 4000)

  listenNinjaHover = ->
    ninjaAssassinSelector = '#ninjaAssassin'
    stormShadowSelector = '#stormShadow'
    ninjaAssassin = $(ninjaAssassinSelector)
    stormShadowCurtain = ninjaAssassin.children('.curtain')
    stormShadow = $(stormShadowSelector)
    ninjaAssassinCurtain = stormShadow.children('.curtain')

    if (not ninjaAssassin.length or not stormShadow.length)
      return
    ninjaAssassin.hover( ->
      if isCoincidental
        return false
      ninjaAssassinCurtain.addClass('active')
      ninjaAssassinCurtain.addClass('hovered')
    , ->
      if isCoincidental
        return false
      ninjaAssassinCurtain.removeClass('active')
      if stormShadowCurtain.hasClass('hovered')
        doAnimation()
    )
    stormShadow.hover( ->
      if isCoincidental
        return false
      stormShadowCurtain.addClass('active')
      stormShadowCurtain.addClass('hovered')
    , ->
      if isCoincidental
        return false
      stormShadowCurtain.removeClass('active')
      if ninjaAssassinCurtain.hasClass('hovered')
        doAnimation()
    )

  listenNinjaHover()

  window.onpopstate = (event) ->
    console.log(history.length)


