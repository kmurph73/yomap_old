App = @App
_ = @_
Territory = App.Territory

App.TerritoryList = Backbone.Collection.extend
  initialize: (options) ->
    App.vent.on 'removeTerritory', @removeTerritory, this

  model: Territory

  findByAttr: (name, prop = 'name') ->
    @find (c) -> c.get(prop) == name

  fetchByName: (name, cb) ->
    item = @findByAttr(name)
    type = item.get('type')
    if item.get('loaded')
      App.vent.trigger 'renderPolygon', item
    else
      if type == 'country'
        Territory.fetchCountry item, (resp) ->
          item.data = resp
          App.vent.trigger 'renderPolygon', item
      else if type == 'state'
        Territory.fetchStates -> App.vent.trigger 'renderPolygon', item
      else if type == 'city'
        Territory.fetchCity item, (resp) ->
          item.data = resp
          App.vent.trigger 'renderPolygon', item

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
