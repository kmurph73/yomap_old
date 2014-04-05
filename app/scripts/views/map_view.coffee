App = @App
_ = @_

App.MapView = Backbone.View.extend
  el: '#map-canvas'

  initialize: (options) ->
    App.vent.on 'renderPolygon', @renderTerritory, @
    App.vent.on 'removeTerritory', @removeTerritory, @
    App.vent.on 'resetTerritory', @resetTerritory, @
    App.vent.on 'centerTerritory', @centerTerritory, @

  removeTerritory: (t) ->
    for poly in t.get('polygons')
      poly.setMap(null)

  resetTerritory: (t) ->
    @removeTerritory(t)
    @renderTerritory(t)

  renderPolygon: (terr, map, points) ->
    coords = []

    for point in points
      if point.length == 2
        coords.push(new google.maps.LatLng(point[0], point[1]))

    polygon = new google.maps.Polygon
      map: map
      paths: coords
      strokeColor: "#FF0000"
      strokeOpacity: 0.8
      strokeWeight: 1
      fillColor: "#FF0000"
      fillOpacity: 0.35
      draggable: true
      geodesic: true

    terr.get('polygons').push polygon

  renderTerritory: (terr) ->
    map = App.data.map
    color = "#FF0000"

    type = terr.get('type')

    if type == 'state'
      color = "#0099FF"
      @renderPolygon(terr, map, terr.points)
    else if type == 'country'
      for poly in terr.data.polygons
        @renderPolygon(terr, map,poly.points)

  centerTerritory: (terr) ->
    map = App.data.map
    center = map.getCenter()
