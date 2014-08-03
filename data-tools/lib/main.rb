require 'byebug'
require 'json'
require './helpers'
require './decoders/city_decoder.rb'
require './decoders/cities_decoder.rb'
require './decoders/states_decoder.rb'
require './decoders/countries_decoder.rb'

root = '/Users/kmurph/code/gmaps/data'

if ARGV.length > 0
  which = ARGV[0]

  if which == 'countries'
    file = "kml/#{which}.kml"
    metadata = CountriesDecoder.new( root: root )
    metadata.decode
  elsif which == 'states'
    file = "kml/#{which}.kml"
    metadata = StatesDecoder.new( root:root)
    metadata.decode
  elsif which =='cities'
    country = ARGV[1]
    state = ARGV[2]
    if not (country && state)
      puts "need city's country and state"
      abort
    end

    if state == 'all'
      metadata = CitiesDecoder.new(
        country: country,
        root: root)

      metadata.decode_all
    else
      metadata = CityDecoder.new(
        country: country,
        state: state,
        root: root
      )

      metadata.decode
    end
  else
    puts "bad arguments: states, cities or countries should be first argument"
    abort
  end
else
  puts "pass in some command-line arguments"
end
