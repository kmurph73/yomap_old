substringMatcher = (strs) ->
  findMatches = (q, cb) ->
    matches = undefined
    substringRegex = undefined
    # an array that will be populated with substring matches
    matches = []
    # regex used to determine if a string contains the substring `q`
    substrRegex = new RegExp(q, "i")
    # iterate through the pool of strings and for any string that
    # contains the substring `q`, add it to the `matches` array
    $.each strs, (i, str) ->
      # the typeahead jQuery plugin expects suggestions to a
      # JavaScript object, refer to typeahead docs for more info
      matches.push value: str  if substrRegex.test(str)

    cb matches

if location.port == '9000'
  url = 'http://localhost:4567'
else
  url = 'http://107.170.247.145'

engine = new Bloodhound
  name: "territories"
  remote: {
    url: "#{url}/territories?q=%QUERY"
    filter: (resp) -> JSON.parse(resp)
    ajax:
      dataType: 'jsonp'
  }
  displayKey: 'name'
  datumTokenizer: (d) -> Bloodhound.tokenizers.whitespace d.val
  queryTokenizer: Bloodhound.tokenizers.whitespace
  limit: 15
  templates: {
    empty: ""
    suggestion: _.template("
      <p><strong><% console.log('heyo')%><%= name %></strong></p>")
  }

promise = engine.initialize()

promise.done(=>
  console.log "success!"

  @$.fn.myTypeAhead = (arr) ->
    @typeahead
      hint: true
      highlight: true
      minLength: 1
    ,
      name: "stuff"
      displayKey: "value"
      source: engine.ttAdapter()
).fail -> console.log "err!"
