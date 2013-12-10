jade = require 'jade'
fs = require 'fs'

exports.index = (req, res) ->
    res.render('gangnam', {
      inHomeState: true
      tabState: ''
      tabContent: ''
    })

renderTabView = (res, name) ->
    fs.readFile("views/tabs/#{name}.jade", 'utf8', (err, data) ->
        if (err)
          console.log(err)
        html = jade.compile(data)({})
        res.render('gangnam', {
          inHomeState: false
          tabState: name
          tabContent: html
          layout: false
        })
    )

exports.introduction = (req, res) ->
    renderTabView(res, 'introduction')

exports.masculinity = (req, res) ->
    renderTabView(res, 'masculinity')

exports.tab = (req, res) ->
    name = req.params.name
    fs.readFile("views/tabs/#{name}.jade", 'utf8', (err, data) ->
        if (err)
          console.log(err)
        html = jade.compile(data)({})
        res.send(html)
    )


