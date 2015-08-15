App = @App
_ = @_

App.TerritoriesView = Backbone.View.extend
  el: '#open-territories'

  initialize: ->
    App.territories.on 'add', @render, @
    App.territories.on 'remove', @render, @

  events:
    'click .action': 'clickAction'

  render: ->
    html = "<ul class='nav nav-pills'>"
    models = App.territories.models
    for terr,index in models
      type = terr.get('type')
      html += """
        <li id='#{type}_#{terr.get('abbrev') || terr.get('terse')}' class="territory-item dropdown">
          <a id="drop4" role="button" data-toggle="dropdown" href="#">#{terr.get('name')}<span class="caret"></span></a>
          <ul id="menu1" class="dropdown-menu" role="menu" aria-labelledby="drop4">
            <li class='action reset' role="presentation"><a role="menuitem" tabindex="-1" href="#">Reset</a></li>
            <li class='action goto' role="presentation"><a role="menuitem" tabindex="-1" href="#">Go to</a></li>
            <li role="presentation" class="divider"></li>
            <li class='action remove' role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
          </ul>
        </li>
      """

    html += "</ul>"

    @$el.html html

  clickAction: (e) ->
    e.preventDefault()

    target = @$(e.currentTarget)

    id = target.closest('.territory-item').attr('id')

    [type,abbrev] = id.split('_')

    if type == 'country'
      territory = App.territories.findWhere(type:type,abbrev:abbrev)
    else if type == 'city'
      territory = App.territories.findWhere(type:type,terse:abbrev)
    else if type == 'state'
      territory = App.territories.findWhere(type:type,name:abbrev)

    if target.hasClass('remove')
      App.territories.remove territory
    else if target.hasClass('reset')
      App.vent.trigger 'resetTerritory', territory
    else if target.hasClass('center')
      App.vent.trigger 'centerTerritory', territory
    else if target.hasClass('goto')
      App.vent.trigger 'gotoTerritory', territory
