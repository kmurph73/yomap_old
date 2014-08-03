require 'byebug'
require 'csv'
require 'json'

root = '/Users/kmurph/code/gmaps/data/data'

Dir.chdir root
csv_file = "#{root}/../your_csv.csv"

types = {
  cities: 'city',
  countries: 'country',
  states: 'state'
}

def slugify(str)
  str.downcase.gsub(' ', '').gsub('ô','o').gsub(/\.|\-|\(|\)/,'')
end

def my_glob(dir)
  Dir.chdir dir
  p 'were'
  p dir
  Dir.glob('*').each do |file|
    yield(file)
  end
  Dir.chdir '..'
end

FileUtils.rm csv_file, :force => true

CSV.open(csv_file, "w") do |csv|
  Dir.glob('*').each do |dir|
    type = types[dir.to_sym]
    Dir.chdir dir do |f|
      if type == 'city'
        Dir.glob('*').each do |country|
          Dir.chdir(country) do |c|
            Dir.glob('*').each do |state_abbrev|
              Dir.chdir(state_abbrev) do
                Dir.glob('*').each do |place|
                  abbrev = place.split('.')[0]
                  hash = JSON.parse(File.open("#{root}/cities/#{country}/#{state_abbrev}/#{abbrev}.json").read)
                  name = hash['name']
                  slug = slugify(name)

                  csv << [type, country, state_abbrev, name, abbrev, slug]
                end
              end
            end
          end
        end
      elsif type == 'country'
        Dir.glob('*').each do |country|
          abbrev = country.split('.')[0]
          hash = JSON.parse(File.open("#{root}/countries/#{abbrev}.json").read)
          name = hash['name']
          csv << [type,nil,nil, name, abbrev, slugify(name)]
        end
      elsif type == 'state'
        country = 'usa'
        Dir.glob('*').each do |state|
          abbrev = state.split('.')[0]
          hash = JSON.parse(File.open("#{root}/states/#{abbrev}.json").read)
          name = hash['name']

          csv << [type, country, nil, name, abbrev, slugify(name)]
        end
      end
    end
  end
end
