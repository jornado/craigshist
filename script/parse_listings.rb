require '../lib/parsehtml'

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

