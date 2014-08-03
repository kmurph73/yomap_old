require 'byebug'
require 'csv'
require 'json'
require 'pg'

conn = PG.connect(dbname: 'dragworld')

root = '/Users/kmurph/code/gmaps/data'

Dir.chdir "#{root}/data/countries"

Dir.glob("*").each do |country|
  abbrev = country.split('.')[0]

  sql = %{ SELECT * FROM territories WHERE territories.abbrev = '#{abbrev}' }

  record = conn.exec(sql).first

  if not record
    hash = JSON.parse(File.open("#{root}/data/countries/#{abbrev}.json").read)
    name = hash['name']
    sql = %{ INSERT INTO territories VALUES ('country',NULL,NULL, $$ #{hash['name']} $$, '#{hash['abbrev']}') }
    record = conn.exec(sql).first
  end
end

Dir.chdir "#{root}/data/cities"

Dir.glob("*").each do |country|
  Dir.chdir country

  Dir.glob("*").each do |state_abbrev|
    Dir.chdir state_abbrev

    Dir.glob("*").each do |place|
      abbrev = place.split('.')[0]

      sql = %{ SELECT * FROM territories WHERE territories.abbrev = '#{abbrev}'
        AND territories.type = 'city'
        AND territories.country = '#{country}'
        AND territories.state = '#{state_abbrev}'
      }

      record = conn.exec(sql).first
      if not record
        hash = JSON.parse(File.open("#{root}/data/cities/#{country}/#{state_abbrev}/#{abbrev}.json").read)
        name = hash['name']
        sql = %{ INSERT INTO territories VALUES ('city','#{country}','#{state_abbrev}', $$ #{hash['name']} $$, '#{abbrev}') }

        record = conn.exec(sql).first
      end
    end
    Dir.chdir '..'
  end

  Dir.chdir '..'
end

Dir.chdir "#{root}/data/states"

Dir.glob("*").each do |file|
  abbrev = file.split('.')[0]
  country = 'usa'

  sql = %{ SELECT * FROM territories WHERE territories.abbrev = '#{abbrev}'
    AND territories.type = 'state'
    AND territories.country = '#{country}'
    AND territories.state = '#{abbrev}'
  }

  record = conn.exec(sql).first

  if not record
    hash = JSON.parse(File.open("#{root}/data/states/#{abbrev}.json").read)
    name = hash['name']

    sql = %{ INSERT INTO territories VALUES ('state','#{country}','#{abbrev}', $$ #{hash['name']} $$, '#{abbrev}') }

    record = conn.exec(sql).first
  end
end

Dir.chdir '..'
