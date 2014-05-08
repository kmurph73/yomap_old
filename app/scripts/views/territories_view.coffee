App = @App
_ = @_

App.TerritoriesView = Backbone.View.extend
  el: '#open-territories'

  initialize: ->
    App.territories.on 'add', @render, @
    App.territories.on 'remove', @render, @

  events:
    'click a': 'clickTerritory'

  render: ->
    html = "<ul>"
    for terr in App.territories.models
      type = terr.get('type')
      html += "
        <span id='#{type}_#{terr.get('abbrev') || terr.get('name')}'>
          #{terr.get('name')}
          <a href='#' class='remove tip' title='remove'>x</a>
          <a></a>
          <a class='reset tip' title='reset'>r</a>
        </span> &bull; "

    html += "</ul>"

    @$el.html html

  clickTerritory: (e) ->
    e.preventDefault()

    target = @$(e.currentTarget)

    id = target.closest('span').attr('id')

    [type,abbrev] = id.split('_')

    if type == 'country' or 'city'
      territory = App.territories.findWhere(type:type,abbrev:abbrev)
    else if type == 'state'
      territory = App.territories.findWhere(type:type,name:abbrev)

    if target.hasClass('remove')
      App.territories.remove territory
    else if target.hasClass('reset')
      App.vent.trigger 'resetTerritory', territory
    else if target.hasClass('center')
      App.vent.trigger 'centerTerritory', territory
