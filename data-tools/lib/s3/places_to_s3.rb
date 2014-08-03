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

if !meta_json['cities']
  meta_json['cities'] = {}
end

cities_json = meta_json['cities']

Dir.chdir "#{root}/data/cities"

territories = []

go = true

Dir.glob("*").each do |country_dir|
  if !cities_json[country_dir]
    cities_json[country_dir] = {}
  end

  Dir.chdir country_dir

  pwd = Dir.pwd

  Dir.glob("*").each do |state_dir|
    if !cities_json[country_dir][state_dir]
      cities_json[country_dir][state_dir] = []
    end

    places = cities_json[country_dir][state_dir]

    Dir.chdir state_dir

    Dir.glob("*").each do |place|
      abbrev = place.split('.')[0]
      meta_place = places.find {|p| p["abbrev"] == abbrev }
      has_s3_file = false

      s3_path = "cities/#{country_dir}/#{state_dir}/#{place}"
      url = "#{url_base}/#{s3_path}"

      begin
        open(url)
        has_s3_file = true
      rescue OpenURI::HTTPError
        has_s3_file = false
      end

      if !meta_place or !has_s3_file
        file = "#{pwd}/#{state_dir}/#{place}"
        file = File.open(file)
        json = JSON.parse file.read
      end

      old_meta = meta_place
      if !meta_place
        puts 'no meta_place'
        p abbrev

        meta_place = {}

        meta_place["name"] = json["name"]
        meta_place["abbrev"] = abbrev

        if has_s3_file
          puts 'no meta and has s3'
          places << meta_place
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

        if resp && !old_meta
          places << meta_place
          File.open(meta_file, 'w') { |file| file.write(meta_json.to_json) }
        end
      end
    end

    Dir.chdir '..'
  end

  Dir.chdir '..'
end
