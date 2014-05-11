App = @App
_ = @_

App.TerritoriesView = Backbone.View.extend
  el: '#open-territories'

  initialize: ->
    App.territories.on 'add', @render, @
    App.territories.on 'remove', @render, @

  events:
    'click i': 'clickTerritory'
    'mouseenter .territory-item': 'enterTerr'
    'mouseleave .territory-item': 'leaveTerr'

  render: ->
    html = "<ul>"
    models = App.territories.models
    for terr,index in models
      type = terr.get('type')
      html += "
        <span class='territory-item' id='#{type}_#{terr.get('abbrev') || terr.get('name')}'>
          #{terr.get('name')}
          <span class='right-arrow'>
            <span>
              <i href='#' class='fa fa-long-arrow-right'></i>
            </span>
          </span>
          <span>
            <span class='actions unimporant-hide'>
              <span>
                <i href='#' class='fa fa-times remove tip' title='remove'></i>
              </span>
              <span>
                <i class='fa fa-refresh reset tip' title='reset'></i>
              </span>
              <span>
                <i class='fa fa-arrows goto tip' title='go to #{terr.get('type')}'></i>
              </span>
            </span>
          </span>"

      if (index + 1) != models.length
          html += "<span><i class='fa fa-circle'></i></span>"

      html += "</span>"

    html += "</ul>"

    @$el.html html

  leaveTerr: (e) ->
    e.preventDefault()

    target = @$(e.currentTarget)

    target.find('.actions').toggle "slide", =>
      target.find('.right-arrow .fa')
      .removeClass('fa-long-arrow-up').addClass('fa-long-arrow-right')

  enterTerr: (e) ->
    e.preventDefault()

    target = @$(e.currentTarget)
    target.find('.actions').toggle "slide", =>
      target.find('.right-arrow .fa')
      .removeClass('fa-long-arrow-right').addClass('fa-long-arrow-up')

  clickTerritory: (e) ->
    e.preventDefault()

    target = @$(e.currentTarget)

    id = target.closest('.territory-item').attr('id')

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
    else if target.hasClass('goto')
      console.log 'goto'
      App.vent.trigger 'gotoTerritory', territory
