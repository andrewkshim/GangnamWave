$ ->
  ninjaAssassinSelector = '#ninjaAssassin'
  stormShadowSelector = '#stormShadow'
  ninjaAssassin = $(ninjaAssassinSelector)
  stormShadowCurtain = ninjaAssassin.children('.curtain')
  stormShadow = $(stormShadowSelector)
  ninjaAssassinCurtain = stormShadow.children('.curtain')
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
    , 4000
    )

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

