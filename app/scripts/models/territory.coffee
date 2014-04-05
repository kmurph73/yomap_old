App = @App
_ = @_

App.Territory = Backbone.Model.extend
  initialize: ->
    @set('polygons', [])

  defaults:
    loaded: false

App.TerritoryList = Backbone.Collection.extend
  initialize: (options) ->
    App.vent.on 'removeTerritory', @removeTerritory, this

  model: App.Territory

  findByAttr: (name, prop = 'name') ->
    @find (c) -> c.get(prop) == name

  fetchByName: (name, cb) ->
    item = @findByAttr(name)
    type = item.get('type')
    if item.get('loaded')
      App.vent.trigger 'renderPolygon', item
    if type == 'country'
      @fetchCountry item, (resp) ->
        item.data = resp
        App.vent.trigger 'renderPolygon', item
    else if type == 'state'
      @fetchStates -> App.vent.trigger 'renderPolygon', item

  setStatePoints: (data) ->
    territories = App.territories

    for datum in data
      state = territories.findByAttr(datum.name)
      state.set('loaded',true)
      state.points = datum.points

  getNames: (names) ->
    final = []

    if _.isArray(names)
      arr = []
      for name,index in names
        arr[index] = @where(type: name)
      final = _.flatten arr
    else
      @where(name:names)

    _.map final, (model) -> model.get('name')

  fetchCountry: (country, cb) ->
    url = "data/countries/#{country.get('abbrev')}.json"

    $.getJSON(url).then (resp) ->
      country.set('loaded',true)
      cb(resp)

  fetchStates: (cb) ->
    $.getJSON("data/states.json").then (resp) =>
      @setStatePoints(resp)
      cb()
