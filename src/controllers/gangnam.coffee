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

exports.section = (req, res) ->
  renderTabView(res, req.params.section)

exports.tab = (req, res) ->
    name = req.params.name
    fs.readFile("views/tabs/#{name}.jade", 'utf8', (err, data) ->
        if (err)
          console.log(err)
        html = jade.compile(data)({})
        res.send(html)
    )


