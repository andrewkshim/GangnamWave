jade = require 'jade'
fs = require 'fs'

exports.index = (req, res) ->
    res.render('gangnam', {
      inHomeState: true
      tabState: ''
      tabContent: ''
    })

exports.introduction = (req, res) ->
    fs.readFile('views/tabs/introduction.jade', 'utf8', (err, data) ->
        if (err)
          console.log(err)
        html = jade.compile(data)({})
        res.render('gangnam', {
          inHomeState: false
          tabState: 'introduction'
          tabContent: html
          layout: false
        })
    )

exports.tab = (req, res) ->
    name = req.params.name
    fs.readFile("views/tabs/#{name}.jade", 'utf8', (err, data) ->
        if (err)
          console.log(err)
        html = jade.compile(data)({})
        res.send(html)
    )


