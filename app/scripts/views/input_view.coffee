App = @App
_ = @_
placeName = null

substringMatcher = (places) ->
  findMatches = (q, cb) ->
    matches = undefined
    substringRegex = undefined
    # an array that will be populated with substring matches
    matches = []
    # regex used to determine if a string contains the substring `q`
    substrRegex = new RegExp(q.replace(/\s|\(|\)/, ''), "i")
    # iterate through the pool of strings and for any string that
    # contains the substring `q`, add it to the `matches` array
    for place in places
      if substrRegex.test(place.terse)
        if matches.length > 20
          break

        if place.type == 'city'
          placeName = place.name + ' (' + place.state + ')'
        else if place.type == 'state'
          placeName = place.name + ' (' + place.country + ')'
        else
          placeName = place.name

        matches.push
          value: placeName
          place: place

    cb matches

App.InputView = Backbone.View.extend
  el: '#side'
  initialize: (options) ->
    names = App.territories.getNames(['state','country','city'])
    App.territories.on 'remove', @clearInput, @
    App.vent.on 'renderPolygon', @clearInput, @

    $.ajax
      type: 'GET'
      dataType: 'json'
      url: 'https://s3-us-west-2.amazonaws.com/yodap/places.json.gz'
      success: (json) =>
        $("input#countryInput").typeahead({
            hint: true
            highlight: true
            minLength: 1
          },
          {
            name: "places"
            source: substringMatcher(json)
          }
        ).on('typeahead:selected', @selected)

  selected: (e, selected, dataName) ->
    target = $(e.currentTarget)
    target.val('')

    territory = App.territories.findOrCreate selected.place

    App.territories.gotime territory

  clearInput: (e) ->
    $('input#countryInput').val('')
