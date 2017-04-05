_ = require 'underscore'
sd = require('sharify').data
Backbone = require 'backbone'
Partner = require '../../../models/partner'
template = -> require('../templates/contact.jade') arguments...
locationTemplate = -> require('../templates/location.jade') arguments...
contactTemplate = -> require('../templates/contact_info.jade') arguments...

module.exports = class PartnerContactView extends Backbone.View
  initialize: (options) ->
    { @profile, @partner } = options

    @listenTo @partner, 'sync', @renderAdditionalInfo
    @partner.related().locations.fetch success: @renderLocations
    @render()

  render: ->
    @$el.html template profile: @profile, partner: @partner

  renderLocations: (locations) =>
    locationStrings = []
    _.each locations.groupBy('city'), (locations, city) ->
      _.each locations, (location) ->
        locationStrings.push locationTemplate(location: location)
    @$('.partner2-locations').html locationStrings.join("")

  renderAdditionalInfo: ->
    @$('.partner2-contact-info').html contactTemplate(profile: @profile, partner: @partner)
