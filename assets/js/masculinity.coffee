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
      $('.ninja-image').removeClass('hovered')
    , 4000
    )

  ninjaAssassin.hover( ->
    ninjaAssassinCurtain.addClass('active')
    ninjaAssassinCurtain.addClass('hovered')
  , ->
    ninjaAssassinCurtain.removeClass('active')
    if stormShadowCurtain.hasClass('hovered')
      doAnimation()
  )
  stormShadow.hover( ->
    stormShadowCurtain.addClass('active')
    stormShadowCurtain.addClass('hovered')
  , ->
    stormShadowCurtain.removeClass('active')
    if ninjaAssassinCurtain.hasClass('hovered')
      doAnimation()
  )
