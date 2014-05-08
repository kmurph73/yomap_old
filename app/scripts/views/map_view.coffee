App = @App
_ = @_

App.MapView = Backbone.View.extend
  el: '#map-canvas'

  initialize: (options) ->
    App.vent.on 'renderPolygon', @renderTerritory, @
    App.territories.on 'remove', @removeTerritory, @
    App.vent.on 'resetTerritory', @resetTerritory, @
    App.vent.on 'centerTerritory', @centerTerritory, @

  removeTerritory: (t) ->
    for poly in t.get('polygons')
      poly.setMap(null)

  resetTerritory: (t) ->
    @removeTerritory(t)
    @renderTerritory(t)

  renderPolygon: (terr, map, coords) ->
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

    for poly in terr.polygons
      @renderPolygon(terr, map, poly)

  centerTerritory: (terr) ->
    map = App.data.map
    center = map.getCenter()

  kmlRender: ->
    layer = new google.maps.FusionTablesLayer(
      query:
        select: "geometry"
        from: "1JccYMnFShp8vhqqn3WC9JysW0vSEHC7cCQ9xK0pf"

      options:
        polygonOptions:
          draggable: true
          geodesic: true
      styles: [
        {
          polygonOptions:
            fillColor: "#00FF00"
            draggable: true
            geodesic: true
        }
      ]
    )

    layer.setMap(App.data.map)
