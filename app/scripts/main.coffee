window.App = App = {}
App.data = data = {}

v = {}
_.extend(v, Backbone.Events)

App.vent = v

$ ->
  $(document).on 'mouseenter', '.tip', -> $(this).tooltip().tooltip('show')
  $(document).on 'mouseleave', '.tip', -> $(this).tooltip('hide')

center = [36.641874, -119.250060]

initialize = ->
  mapOptions =
    zoom: 5
    center: new google.maps.LatLng(center[0], center[1])
    mapTypeId: google.maps.MapTypeId.TERRAIN

  data.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

google.maps.event.addDomListener window, "load", initialize
