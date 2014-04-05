window.App = App = {}
App.data = data = {}

v = {}
_.extend(v, Backbone.Events)

App.vent = v

$ ->
  $(document).on 'mouseenter', '.tip', -> $(this).tooltip().tooltip('show')
  $(document).on 'mouseleave', '.tip', -> $(this).tooltip('hide')

initialize = ->
  mapOptions =
    zoom: 3
    center: new google.maps.LatLng(24.4441, 121.19313333333334)
    mapTypeId: google.maps.MapTypeId.TERRAIN

  data.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

google.maps.event.addDomListener window, "load", initialize
