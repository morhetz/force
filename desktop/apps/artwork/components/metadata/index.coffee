follow = require '../../lib/follow'

module.exports = ->
  $el = $('.js-artwork-metadata')

  follow $el.find '.js-artist-follow-button'
