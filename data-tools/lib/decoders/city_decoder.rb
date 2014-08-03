require 'byebug'
require 'nokogiri'

class CityDecoder
  def initialize(options)
    @country = options[:country]
    @state   = options[:state]
    @root    = options[:root]

    @path =  "#{@root}/kml/cities/#{@country}"
    @kml_file = "#{@path}/#{@state}_places.kml"
  end

  def decode
    cities_xml = Nokogiri::XML(File.open(@kml_file))
    cities_xml.css('Placemark').each do |p|
      hash = {}

      thing = p.search('SimpleData[@name=NAMELSAD]')[0]
      if thing
        name = thing.text()

        hash[:name] = name
        abbrev = to_slug(name)

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

        hash[:polygons] = polygons

        file = "#{@root}/data/cities/#{@country}/#{@state}/#{abbrev}.json"

        puts 'file'
        puts file

        File.open(file, 'w') { |f| f.write(hash.to_json) }
      end
    end
  end
end
