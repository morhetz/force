Backbone = require 'backbone'
Q = require 'bluebird-q'
Aggregations = require '../collections/aggregations.coffee'
Artworks = require '../../../collections/artworks.coffee'
metaphysics = require '../../../lib/metaphysics.coffee'

module.exports = class Filter extends Backbone.Model
  defaults:
    loading: false

  initialize: ({ @params } = {}) ->
    throw new Error 'Requires a params model' unless @params?
    @artworks = new Artworks()
    @aggregations = new Aggregations()

    @params.on 'change', @fetch, @

  includeAggregations: ->
    @params.get('page') is 1 or @aggregations.length == 0

  aggregationSelector: ->
    if @includeAggregations()
      require '../queries/aggregations_selector.coffee'
    else
      ''

  aggregationFragment: ->
    if @includeAggregations()
      require '../queries/aggregations.coffee'
    else
      ''

  query: ->
    query = """
      query filterArtworks(
        $aggregations: [ArtworkAggregation],
        $for_sale: Boolean,
        $height: String,
        $width: String
        $page: Int,
        $size: Int,
        $color: String,
        $price_range: String,
        $gene_id: String,
        $medium: String,
        $sort: String,
        $extra_aggregation_gene_ids: [String]
      ){
        filter_artworks(
          aggregations: $aggregations,
          for_sale: $for_sale,
          page: $page,
          size: $size,
          width: $width,
          height: $height,
          color: $color,
          price_range: $price_range,
          gene_id: $gene_id,
          medium: $medium,
          sort: $sort,
          extra_aggregation_gene_ids: $extra_aggregation_gene_ids
        ){
          total
          #{@aggregationSelector()}
          hits {
            ... artwork
          }
        }
      }
      #{require '../queries/artwork.coffee'}
      #{@aggregationFragment()}
    """

  fetch: ->
    @set loading: true
    Q.promise (resolve, reject) =>
      metaphysics query: @query(), variables: @params.current()
        .then ({ filter_artworks }) =>
          if filter_artworks.hits.length
            @artworks.reset filter_artworks.hits
          else
            @artworks.trigger 'zero:results', false
          @set loading: false
          @set total: filter_artworks.total
          @aggregations.reset filter_artworks.aggregations if filter_artworks.aggregations
          resolve @
        .catch (error) ->
          reject error
