require 'nokogiri'
require 'pry'
require 'json'
require 'byebug'

countries_file = 'kml/countries.kml'
states_file = 'kml/states.xml'
cities_file = 'kml/ca_places.kml'

countries_xml = Nokogiri::XML(File.open(countries_file))
states_xml = Nokogiri::XML(File.open(states_file))
ca_cities_xml = Nokogiri::XML(File.open(cities_file))

["scalerank", "featurecla", "LABELRANK", "SOVEREIGNT", "SOV_A3", "ADM0_DIF", "LEVEL", "TYPE", "ADMIN", "ADM0_A3", "GEOU_DIF", "GEOUNIT", "GU_A3",
"SU_DIF", "SUBUNIT", "SU_A3", "BRK_DIFF", "NAME_LONG", "BRK_A3", "BRK_NAME", "ABBREV", "POSTAL", "FORMAL_EN", "NAME_SORT",
"MAPCOLOR7", "MAPCOLOR8", "MAPCOLOR9", "MAPCOLOR13", "POP_EST", "GDP_MD_EST", "POP_YEAR", "LASTCENSUS", "GDP_YEAR", "ECONOMY", "INCOME_GRP",
"WIKIPEDIA", "FIPS_10_", "ISO_A2", "ISO_A3", "ISO_N3", "UN_A3", "WB_A2", "WB_A3", "WOE_ID", "WOE_ID_EH", "WOE_NOTE",
"ADM0_A3_IS", "ADM0_A3_US", "ADM0_A3_UN", "ADM0_A3_WB", "CONTINENT", "REGION_UN", "SUBREGION", "REGION_WB", "NAME_LEN", "LONG_LEN", "ABBREV_LEN",
"TINY", "HOMEPART"]

metadata = {
  countries: [],
  cities: [],
  states: []
}

def to_slug(str)
  str.gsub(/[.'`]/,"").downcase.

  #replace all non alphanumeric, underscore or periods with underscore
  gsub /\s*[^A-Za-z0-9\.\-]\s*/, ''
end

def find_thing(data,name)
  r = data.find { |d| d['name'] == name }
  if !r
    r = data.find { |d| d['name'] == 'ADM0_A' }
    if !r
      r = data.find { |d| d['name'] == 'SU_A3' }
      if !r
        p data
      end
    end
  end

  if r
    r.text
  end
end

places = []

countries_xml.css('Placemark').each do |p|
  meta = {}
  hash = {}
  data = p.css('SimpleData')

  hash[:pop] = find_thing(data, 'POP_EST')
  hash[:name] = meta[:name] = find_thing(data, 'BRK_NAME')
  hash[:abbrev] = h = meta[:abbrev] = find_thing(data, 'ABBREV')

  if h
    hash[:abbrev_slug] = slug = to_slug(hash[:abbrev])
  end

  hash[:polygons] = []

  p.css('coordinates').each do |poly|
    polygon = {}
    polygon[:points] = []
    poly.text.split(',').each do |s|
      polygon[:points] << s.split(' ').map {|n| n.to_f }
    end

    hash[:polygons] << polygon
  end

  File.open("app/data/countries/#{slug}.json", 'w') { |file| file.write(hash.to_json) }
  metadata[:countries] << meta
end

states = []

states_xml.css('state').each do |s|
  meta = {}
  hash = {}
  points = []

  hash[:name] = meta[:name] = s[:name]
  hash[:points] = points

  s.css('point').each do |p|
    points << [p[:lat].to_f, p[:lng].to_f]
  end

  metadata[:states] << meta
  states << hash
end

File.open('app/data/states.json', 'w') { |file| file.write(states.to_json) }

cities = []

ca_cities_xml.css('Placemark').each do |p|
  meta = {}
  hash = {}

  thing = p.search('SimpleData[@name=NAMELSAD]')[0]
  if thing
    name = thing.text()

    hash[:name] = meta[:name] = name
    meta[:abbrev] = abbrev = to_slug(name)

    polygons = []

    p.css('Polygon').map do |polygon|
      poly = {innerCoords: []}
      outerCoords = polygon.css('outerBoundaryIs')[0].css('coordinates')[0].text().split(' ').map {|c| c.split(',') }

      if abbrev == 'sanluisobispocity'
        p 'outerCoords'
        p outerCoords
      end

      poly[:outerCoords] = outerCoords

      innerBoundary = polygon.css('innerBoundaryIs')

      innerBoundary.each do |ib|
        innerCoords = ib.css('coordinates')[0].text().split(' ').map {|c| c.split(',') }
        if abbrev == 'sanluisobispocity'
          p 'innerCoords'
          p innerCoords
        end

        poly[:innerCoords].push innerCoords
      end

      polygons << poly
    end

    metadata[:cities] << meta
    hash[:polygons] = polygons

    File.open("app/data/cities/usa/ca/#{abbrev}.json", 'w') { |file| file.write(hash.to_json) }

    cities << hash
  end
end

File.open('app/data/meta.json', 'w') { |file| file.write(metadata.to_json) }
