require '../lib/parsehtml'
require '../lib/geocode'
require '../lib/models'

# get urls from page
# loop through urls
# check if posting id is in db
# if not, fetch page
# get next url

environment = "development"
config = YAML.load_file('../config/craigshist.yml')

parser = ParseHtmlListings.new
parser.init(environment)
parser.go(config[environment]["listings_url"])

geocode = Geocode.new
# get zipcode for each
Listing.all().each { |listing|
  puts listing.title
  puts listing.address
  zip = geocode.get(listing.address)
  puts zip
  puts
  
  if not zip.nil? and not zip.zip.nil?
    code = ZipCode.first_or_create(:zip_code => zip.zip.gsub(/-\d+/, ''))
    code.lat = zip.lat
    code.lng = zip.lng
    code.save
    
    listing.zip_code = code
    listing.save
  end
}
