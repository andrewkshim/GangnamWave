$ ->

  slantTabSelector = '.slant-tab'
  hiddenSlantTabSelector = "#{slantTabSelector}.hidden"
  slantTabContainerSelector = "#{slantTabSelector}-container"
  slantTabContentSelector = "#{slantTabSelector}-content"
  titleContainerSelector = '#title-container'
  slantDrawerSelector = '#slant-drawer'

  $(slantTabSelector).click( (event) ->
    clickedTab = $(this)
    clickedTabPosition = $(this).offset()
    $(slantTabContentSelector).each( ->
      $(this).addClass('active', 500, 'easeOutQuad')
    )
    $(this).addClass('main')
    $('.slant').addClass('hidden', 500, 'easeOutQuad')
  ).hover( (event) ->
    $(this).addClass('hovered', 500, 'linear')
  , (event) ->
    $(this).removeClass('hovered', 500, 'linear')
  )

  hideSlantTabs = ->
    timeElapsed = 200
    $(slantTabSelector).each( (index, element) ->
      setTimeout( ->
        $(element).addClass('hidden', 500, 'easeOutQuad')
      , 100 * (index+1))
      timeElapsed += 100
    )
    setTimeout( ->
      $(slantDrawerSelector).addClass('hidden')
    , timeElapsed/2)
    setTimeout( ->
      $(titleContainerSelector).removeClass('hidden')
    , timeElapsed)

  revealHiddenSlantTabs = ->
    $(hiddenSlantTabSelector).each( (index, element) ->
      setTimeout( ->
        $(element).removeClass('hidden', 500, 'easeOutQuad')
      , 100 * (index+1))
    )
    $(titleContainerSelector).addClass('hidden')
    $(slantDrawerSelector).removeClass('hidden')

  toggleSlantTabs = ->
    if ($(hiddenSlantTabSelector).length)
      revealHiddenSlantTabs()
    else
      hideSlantTabs()

  $('#menu-button').click( (event) ->
    toggleSlantTabs()
  )

  $('#home-button, #header-title').click( (event) ->
    hideSlantTabs()
  )

  $(window)
    .focus( (event) ->
      document.getElementById('gangnamVideo').play()
    )
    .blur( (event) ->
      document.getElementById('gangnamVideo').pause()
    )


