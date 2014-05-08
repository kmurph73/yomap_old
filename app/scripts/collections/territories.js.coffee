App = @App
_ = @_
Territory = App.Territory

App.TerritoryList = Backbone.Collection.extend
  initialize: (options) ->
    App.vent.on 'removeTerritory', @removeTerritory, @

  model: Territory

  findByAttr: (name, prop = 'name') ->
    @find (c) -> c.get(prop) == name

  findOrCreate: (obj) ->
    model = @findWhere
      abbrev: obj.abbrev
      state: obj.state
      country: obj.country
      type: obj.type

    if !model
      model = @add obj

    model

  gotime: (terr) ->
    type = terr.get('type')
    if terr.data
      App.vent.trigger 'renderPolygon', terr
    else
      if type == 'country'
        Territory.fetchCountry terr, (resp) ->
          terr.data = resp
          App.vent.trigger 'renderPolygon', terr
      else if type == 'state'
        Territory.fetchStates -> App.vent.trigger 'renderPolygon', terr
      else if type == 'city'
        Territory.fetchCity terr, (resp) ->
          terr.polygons = resp
          App.vent.trigger 'renderPolygon', terr

  addList: (list,attrs) ->
    for territory in list
      terr = new Territory territory
      terr.set(attrs)
      @add(terr)

  setAll: (meta) ->
    for type,list of meta
      if type == 'countries'
        typeName = 'country'
      else if type == 'cities'
        typeName = 'city'
      else if type == 'states'
        typeName = 'state'

      if type == 'countries'
        attrs = {type: typeName}
        @addList(list,attrs)
      else
        for country in list
          for countryName,terrs of country
            attrs = {type: typeName, country: countryName}
            @addList(terrs,attrs)

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
