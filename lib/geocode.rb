require 'geokit'

class Geocode
  
  def get(address)
    Geokit::Geocoders::YahooGeocoder.geocode address
  end
  
  def get_zipcode(address)
    code = get(address)
    if not code.zip.nil?
      return code.zip.gsub(/-\d+/, '')
    else
      return
    end
  end
  
end