App = @App
_ = @_
LatLng = @google.maps.LatLng

gmapify = (points) -> _.map points, (point) -> new LatLng(point[0],point[1])

purgeSinglePoints = (polygons) ->
  for polygon in polygons
    polygon.points = gmapify(_.reject(polygon.points, (point) -> point.length < 2))

App.Territory = Territory = Backbone.Model.extend
  initialize: ->
    @set('polygons', [])

  defaults:
    loaded: false

Territory.fetchCountry = (country, cb) ->
  url = "data/countries/#{country.get('abbrev')}.json"

  $.getJSON(url).then (resp) ->
    purgeSinglePoints(resp.polygons)
    country.set('loaded',true)
    cb(resp)

Territory.fetchCity = (city, cb) ->
  url = "data/cities/usa/ca/#{city.get('abbrev')}.json"
  $.getJSON(url).then (resp) ->
    newResp = {}
    newResp.polygons = _.map resp.polygons, (poly) ->
      gon = []

      outerCoords = _.map poly.outerCoords, (point) -> new LatLng point[1],point[0]
      innerCoords = _.map poly.innerCoords, (coords) -> _.map coords, (point) -> new LatLng point[1],point[0]

      gon.push outerCoords

      for c in innerCoords
        gon.push c

      gon

    city.set('loaded',true)
    cb(newResp)

Territory.fetchStates = (cb) ->
  $.getJSON("data/states.json").then (resp) =>
    territories = App.territories
    for datum in resp
      state = territories.findByAttr(datum.name)
      state.set('loaded',true)
      state.points = gmapify(datum.points)

    cb()
