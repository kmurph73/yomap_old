require 'byebug'
require 'json'
require 'aws-sdk'
require 'open-uri'

s3 = AWS::S3.new
bucket = s3.buckets['yodap']

root = '/Users/kmurph/code/gmaps/data'

meta_file = "#{root}/data/meta.json"
meta_json = JSON.parse(File.open(meta_file).read)

url_base = 'https://s3-us-west-2.amazonaws.com/yodap'

if !meta_json['countries']
  meta_json['countries'] = {}
end

countries_json = meta_json['countries']

Dir.chdir "#{root}/data/countries"

countries = []

go = true

Dir.glob("*").each do |country|
  abbrev = country.split('.')[0]
  meta_country = countries.find {|p| p["abbrev"] == abbrev }
  has_s3_file = false

  s3_path = "countries/#{country}"
  url = "#{url_base}/#{s3_path}"

  begin
    open(url)
    has_s3_file = true
  rescue OpenURI::HTTPError
    has_s3_file = false
  end

  if !meta_country or !has_s3_file
    file = "#{root}/data/countries/#{country}"
    file = File.open(file)
    json = JSON.parse file.read
  end

  old_meta = meta_country
  if !meta_country
    puts 'no meta_country'
    p abbrev

    meta_country = {}

    meta_country["name"] = json["name"]
    meta_country["abbrev"] = abbrev

    if has_s3_file
      puts 'no meta and has s3'
      countries << meta_country
      File.open(meta_file, 'w') { |file| file.write(meta_json.to_json) }
    end
  end

  if !has_s3_file
    if old_meta
      puts 'has meta, but no s3 file'
    else
      puts 'has no meta and no s3'
    end
    puts abbrev

    resp = bucket.objects[s3_path].write(file, acl: :public_read)
    puts 'resp'
    p resp

    if resp && !old_meta
      countries << meta_country
      File.open(meta_file, 'w') { |file| file.write(meta_json.to_json) }
    end
  end
end
