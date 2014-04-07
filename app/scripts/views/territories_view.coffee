App = @App
_ = @_

App.TerritoriesView = Backbone.View.extend
  el: '#open-territories'

  initialize: ->
    App.openTerritories.on 'add', @render, @
    App.openTerritories.on 'remove', @render, @

  events:
    'click a': 'clickTerritory'

  render: ->
    html = ""
    for terr in App.openTerritories.models
      type = terr.get('type')
      html += "
        <span id='#{type}_#{terr.get('abbrev') || terr.get('name')}'>
          #{terr.get('name')}
          <a href='#' class='remove tip' title='remove'>x</a>
          <a></a>
          <a class='reset tip' title='reset'>r</a>
        </span>"

    @$el.html html

  clickTerritory: (e) ->
    e.preventDefault()

    target = @$(e.currentTarget)

    id = target.closest('span').attr('id')

    [type,abbrev] = id.split('_')

    if type == 'country' or 'city'
      territory = App.openTerritories.findWhere(type:type,abbrev:abbrev)
    else if type == 'state'
      territory = App.openTerritories.findWhere(type:type,name:abbrev)

    if target.hasClass('remove')
      App.vent.trigger 'removeTerritory', territory
    else if target.hasClass('reset')
      App.vent.trigger 'resetTerritory', territory
    else if target.hasClass('center')
      App.vent.trigger 'centerTerritory', territory
