App = @App
_ = @_
maps = @google.maps
LatLng = maps.LatLng

gmapifyPoints = (points) -> _.map points, (point) -> new LatLng(point[1],point[0])

gmapifyPolygons = (polygons) ->
  _.map polygons, (poly) ->
    gon = []

    outerCoords = gmapifyPoints(purgeLonePoints(poly.outerCoords))
    innerCoords = _.map poly.innerCoords, (coords) -> gmapifyPoints(purgeLonePoints(coords))

    gon.push outerCoords

    for c in innerCoords
      gon.push c

    gon

purgeLonePoints = (coords) -> _.reject(coords, (point) -> point.length < 2)

root = 'https://s3-us-west-2.amazonaws.com/yodap'

rad = (x) -> x * Math.PI / 180

getDistance = (p1, p2) ->
  R = 6378137 # Earth’s mean radius in meter
  dLat = rad(p2.lat() - p1.lat())
  dLong = rad(p2.lng() - p1.lng())
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(rad(p1.lat())) * Math.cos(rad(p2.lat())) * Math.sin(dLong / 2) * Math.sin(dLong / 2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  d = R * c
  d # returns the distance in meter

App.Territory = Territory = Backbone.Model.extend
  initialize: ->
    @set('polygons', [])

  defaults:
    loaded: false

  getCenter: ->
    bounds = new maps.LatLngBounds()
    polygons = @polygons
    points = polygons[0][0]

    for p in points
      bounds.extend p

    bounds.getCenter()

Territory.fetchCountry = (country, cb) ->
  url = "#{root}/countries/#{country.get('abbrev')}.json"

  $.getJSON(url).then (resp) ->
    polygons = gmapifyPolygons(resp.polygons)

    cb(polygons)

Territory.fetchCity = (item, cb) ->
  url = "#{root}/cities/#{item.get('country')}/#{item.get('state')}/#{item.get('terse')}.json"
  $.getJSON(url).then( (resp) ->
    polygons = gmapifyPolygons(resp.polygons)

    cb(polygons)
  ).fail( (fail) -> debugger )

Territory.fetchState = (item, cb) ->
  $.getJSON("#{root}/states/#{item.get('abbrev')}.json").then (resp) =>
    polygons = gmapifyPolygons(resp.polygons)
    cb(polygons)
