App = @App
_ = @_
LatLng = @google.maps.LatLng

gmapify = (points) -> _.map points, (point) -> new LatLng(point[0],point[1])

purgeLonePoints = (coords) -> _.reject(coords, (point) -> point.length < 2)

root = 'https://s3-us-west-2.amazonaws.com/yodap'

App.Territory = Territory = Backbone.Model.extend
  initialize: ->
    @set('polygons', [])

  defaults:
    loaded: false

Territory.fetchCountry = (country, cb) ->
  url = "#{root}/countries/#{country.get('abbrev')}.json"

  $.getJSON(url).then (resp) ->
    purgeLonePoints(resp.polygons)
    country.set('loaded',true)
    cb(resp)

Territory.fetchCity = (item, cb) ->
  url = "#{root}/cities/#{item.get('country')}/#{item.get('state')}/#{item.get('abbrev')}.json"
  $.getJSON(url).then( (resp) ->
    polygons = _.map resp.polygons, (poly) ->
      gon = []

      outerCoords = _.map purgeLonePoints(poly.outerCoords), (point) -> new LatLng(point[1],point[0])
      innerCoords = _.map poly.innerCoords, (coords) -> _.map purgeLonePoints(coords), (point) -> new LatLng(point[1],point[0])

      resp

      gon.push outerCoords

      for c in innerCoords
        gon.push c

      gon

    cb(polygons)
  ).fail( (fail) -> debugger )

Territory.fetchStates = (cb) ->
  $.getJSON("data/states.json").then (resp) =>
    territories = App.territories
    for datum in resp
      state = territories.findByAttr(datum.name)
      state.set('loaded',true)
      state.points = gmapify(datum.points)

    cb()
