require 'nokogiri'
require 'pry'
require 'json'
require 'byebug'

if ARGV.length > 0
  which = ARGV[0]

  meta_file = 'app/data/meta.json'

  if which == 'countries' || which == 'states'
    file = "kml/#{which}.kml"
  elsif which =='cities'
    city_country = ARGV[1]
    city_state = ARGV[2]
    if not (city_state && city_country)
      puts "need city's country and state"
      abort
    end

    file = "kml/cities/#{city_country}/#{city_state}_places.kml"
  else
    puts "bad arguments: states, cities or countries should be first argument"
    abort
  end

  meta_json = JSON.parse(meta_file.read)

  xml = Nokogiri::XML(File.open(file))

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

  if which == 'countries'

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
  elsif which == 'states'
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
  elsif which == 'cities'
    cities = []
    state_sym == which_state.to_sym
    country_sym == which_country.to_sym

    cities_xml.css('Placemark').each do |p|
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

          poly[:outerCoords] = outerCoords

          innerBoundary = polygon.css('innerBoundaryIs')

          innerBoundary.each do |ib|
            innerCoords = ib.css('coordinates')[0].text().split(' ').map {|c| c.split(',') }

            poly[:innerCoords].push innerCoords
          end

          polygons << poly
        end

        metadata[which_state.to_sym] == meta
        hash[:polygons] = polygons

        data_file = "app/data/#{which}/#{which_country}/#{which_state}/#{abbrev}.json"

        File.open(data_file, 'w') { |file| file.write(hash.to_json) }

        cities << hash
      end
    end
  end

  File.open(meta_file, 'w') { |file| file.write(metadata.to_json) }
else
  puts "pass in some command-line arguments"
end
