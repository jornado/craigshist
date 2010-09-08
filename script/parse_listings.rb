require '../lib/parse'

# get urls from page
# loop through urls
# check if posting id is in db
# if not, fetch page
# get next url

url = "http://portland.craigslist.org/search/apa/mlt?query=&srchType=A&minAsk=&maxAsk=&bedrooms=1"
parser = ParseHtmlListings.new
parser.parse(url)