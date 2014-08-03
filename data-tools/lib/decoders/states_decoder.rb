require 'byebug'

class StatesDecoder
  def initialize(options)
    @root = options[:root]

    @path = "#{@root}/kml"
    @kml_file = "#{@path}/us_states.kml"
  end

  def decode
    states_xml = Nokogiri::XML(File.open(@kml_file))
    metas = []
    states_xml.css('Placemark').each do |p|
      hash = {}

      name = p.search 'name'

      data = p.search('SimpleData')

      hash[:name] = name = name[0].text()
      hash[:abbrev] = abbrev = to_slug(find_thing(data, 'STUSPS'))

      polygons = []

      p.css('Polygon').map do |polygon|
        poly = {innerCoords: []}
        outerCoords = polygon.css('outerBoundaryIs')[0].css('coordinates')[0].text().split(' ').map {|c| c.split(',') }

        poly[:outerCoords] = outerCoords

        innerBoundary = polygon.css('innerBoundaryIs')

        if innerBoundary.length > 0
          puts "Has inner boundaries: " + name
          puts abbrev
        end

        innerBoundary.each do |ib|
          innerCoords = ib.css('coordinates')[0].text().split(' ').map {|c| c.split(',') }

          poly[:innerCoords].push innerCoords
        end

        polygons << poly
      end

      hash[:polygons] = polygons

      file = "#{@root}/data/states/#{abbrev}.json"

      File.open(file, 'w') { |f| f.write(hash.to_json) }
    end
  end
end
