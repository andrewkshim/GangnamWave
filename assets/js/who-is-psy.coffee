$ ->

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
    $('.psy-age').html(getPsyAge())

  setPsyAge()

