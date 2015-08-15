require 'json'
require 'csv'

places = []

CSV.foreach("data-tools/your_csv.csv") do |row|
  if row[0] == 'city'
    places.push({
      type: 'city',
      country:row[1],
      state: row[2],
      name: row[3],
      terse: row[4]
    })
  elsif row[0] == 'state'
    places.push({
      type: 'state',
      country: row[1],
      name: row[3],
      abbrev: row[4],
      terse: row[5]
    })
  elsif row[0] == 'country'
    places.push({
      type: 'country',
      name: row[3],
      abbrev: row[4],
      terse: row[5]
    })
  end
end

File.open('data-tools/places.json', 'w') { |file|
  file.write(places.to_json)
  #file.write(JSON.pretty_generate(places))
}
