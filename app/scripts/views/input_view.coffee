App = @App
_ = @_

App.InputView = Backbone.View.extend
  el: '#side'
  initialize: (options) ->
    names = App.territories.getNames(['state','country','city'])
    App.territories.on 'remove', @clearInput, @
    App.vent.on 'renderPolygon', @clearInput, @

    $("input#countryInput").myTypeAhead(names).on('typeahead:selected', @selected)

  selected: (e, selected, dataName) ->
    target = $(e.currentTarget)
    target.val('')

    territory = App.territories.findOrCreate selected

    App.territories.gotime territory

  clearInput: (e) ->
    $('input#countryInput').val('')
