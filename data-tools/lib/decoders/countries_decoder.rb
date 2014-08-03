require 'byebug'

class CountriesDecoder
  def initialize(options)
    @root = options[:root]

    @path = "#{@root}/kml"
    @kml_file = "#{@path}/countries.kml"
  end

  def decode
    cities_xml = Nokogiri::XML(File.open(@kml_file))
    metas = []
    cities_xml.css('Placemark').each do |p|
      hash = {}

      data = p.search('SimpleData')

      hash[:name] = name = find_thing(data, 'BRK_NAME')
      hash[:abbrev] = abbrev = to_slug(find_thing(data, 'ABBREV'))

      polygons = []

      p.css('Polygon').map do |polygon|
        poly = {innerCoords: []}
        outerCoords = polygon.css('outerBoundaryIs')[0].css('coordinates')[0].text().split(' ').map {|c| c.split(',') }

        poly[:outerCoords] = outerCoords

        innerBoundary = polygon.css('innerBoundaryIs')

        if innerBoundary.length > 0
          puts name
          puts abbrev
        end

        innerBoundary.each do |ib|
          innerCoords = ib.css('coordinates')[0].text().split(' ').map {|c| c.split(',') }

          poly[:innerCoords].push innerCoords
        end

        polygons << poly
      end

      hash[:polygons] = polygons

      file = "#{@root}/data/countries/#{abbrev}.json"

      File.open(file, 'w') { |f| f.write(hash.to_json) }
    end
  end
end
