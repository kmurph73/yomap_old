meta = @meta
$ ->
  App.territories = territories = new App.TerritoryList(meta.countries.concat(meta.states))
  App.openTerritories = open = new App.TerritoryList
  new App.InputView
  new App.TerritoriesView
  new App.MapView

  App.vent.on 'renderPolygon', (item) ->
    open.add(item)

  App.vent.on 'removeTerritory', (terr) ->
    open.remove(terr)
