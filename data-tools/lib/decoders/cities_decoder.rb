require 'byebug'
require 'nokogiri'

class CitiesDecoder
  def initialize(options)
    @country = options[:country]
    @root = options[:root]
  end

  def decode_all
    country = @country
    Dir.chdir "#{@root}/kml/cities/#{country}"

    states = Dir.glob("#{@root}/data/cities/#{country}/*").map do |file|
      file.split('/')[-1]
    end
    puts 'states'
    p states

    Dir.glob("*").each do |state_kml|
      abbrev = state_kml.split('_')[0]

      state = states.find {|s| s == abbrev}
      p 'state'
      p state

      if !state
        puts "decoding state: #{abbrev}"
        Dir.mkdir "#{@root}/data/cities/#{country}/#{abbrev}"
        dec = CityDecoder.new(
          country: country,
          state: abbrev,
          root: @root
        )

        dec.decode
      end

    end
  end
end
