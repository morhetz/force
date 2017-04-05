sd = require('sharify').data
Backbone = require 'backbone'
FairEntry = require '../models/fair_entry'

module.exports = class FairEntries extends Backbone.Collection
  model: FairEntry

  url: -> "#{sd.EUROPA_URL}/api/entries"
