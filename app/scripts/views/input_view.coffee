App = @App
_ = @_

App.InputView = Backbone.View.extend
  el: '#side'
  initialize: (options) ->
    names = App.territories.getNames(['state','country'])
    App.openTerritories.on 'remove', @clearInput, @
    App.vent.on 'renderPolygon', @clearInput, @

    $("input#countryInput").myTypeAhead(names).on('typeahead:selected', @selected)

  selected: (e, selected, dataName) ->
    target = $(e.currentTarget)
    target.val('')

    val = selected.value

    App.territories.fetchByName(val)

  clearInput: (e) ->
    $('input#countryInput').val('')
