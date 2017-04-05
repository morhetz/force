modalize = require '../../../../../../components/modalize/index'
Auction = require '../../../../../../models/auction'
fetchBuyersPremium = require '../../../../../../components/buyers_premium/index'

module.exports = (auction_id) ->
  $el = $('<div></div>')

  view = render: -> $el: $el

  modal = modalize view,
    className: 'modalize artwork-auction-buyers-premium-modal'
    dimensions: width: '700px'

  auction = new Auction id: auction_id

  modal.load (open) ->
    auction.fetch().then ->
      fetchBuyersPremium auction, (err, html) ->
        $el.html html
        open()

  modal
