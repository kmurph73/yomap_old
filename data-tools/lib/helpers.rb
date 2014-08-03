def to_slug(str)
  str.gsub(/[.'`]/,"").downcase.

  #replace all non alphanumeric, underscore or periods with underscore
  gsub /\s*[^A-Za-z0-9\.\-]\s*/, ''
end

def find_thing(data,name)
  r = data.find { |d| d['name'] == name }
  if !r
    r = data.find { |d| d['name'] == 'ADM0_A' }
    if !r
      r = data.find { |d| d['name'] == 'SU_A3' }
      if !r
        p data
      end
    end
  end

  if r
    r.text
  end
end
