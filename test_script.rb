require 'nokogiri'
require 'pry'
require 'json'
require 'byebug'

cities_file = 'kml/city_boundaries.kml'

cities_xml = Nokogiri::XML(File.open(cities_file))

cities = []

cities_xml.css('Placemark').each do |p|
  meta = {}
  hash = {}
  points = []

  hash[:points] = points

  name = p.search('SimpleData[@name=namelsad]')[0]

  hash[:name] = meta[:name] = name

  hash[:points] = p.css('coordinates').split(' ').map {|c| c.split(',') }

  metadata[:cities] << meta
  cities << hash
end
