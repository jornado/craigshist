require 'rubygems'
require "hpricot"
require "open-uri"
require 'dm-core'
require './lib/models.rb'
require './lib/chdebug'

# generic parsing routines
class ParseHtml < CHDebug
  
  def init(env='development')
    #@@config = YAML.load_file( '../config/craigshist.yml' )
    #@@env = env
    #@@debug = @@config[@@env]['debug']
    super
    
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/./#{@@config[@@env]['database']}")
    debug "...Initializing... (#{env})\n\n"
    
  end
  
  protected
  
  # s represents start point (i.e., 0, 100, 200, etc)
  def open_url(url, s)
    if s.nil?
      url = url
    else
      url = "#{url}&s=#{s}"
    end
    
    doc = nil
    begin
      doc = Hpricot(open(url))
    rescue Timeout::Error
      return self.open_url(url, s)
    else
      return doc
    end
    
  end
  
  def parse(url, s=nil)
    return self.open_url(url, s)
  end
  
end

# routines specific to one listing
class ParseHtmlListing < ParseHtml
  
  protected

  def exists?(url)
    url =~ /(\d+)\.html/
    return 1 if $1.nil?
    # check if it's already been crawled
    
    debug "Checking if listing #{$1} exists in db"
    existing = Listing.first(:posting_id => $1)
    
    if existing.nil?
      return
    else
      return 1
    end
    
  end
  
  # for non-url-fetchy debug (use instead of listing = self.open_url(url, nil) in self.fetch())
  def test_listing()
    Hpricot(open(@@config[@@env]['test_html']))
  end
  
  def fetch(url, text)
    debug "Fetching #{url}"
    
    if self.exists?(url)
      debug "Already exists in db"
      return
    else
      
      # only 1brs, for example
      return if not text =~ /#{@@config[@@env]['num_bedrooms']}/
      
      debug "Opening URL #{url}"
      listing = self.open_url(url, nil)
      
      vals = self.parse_html(listing, url)
      
      if not vals.nil?
        self.create_record(vals)
      end
      
    end
    
  end
  
  # insert listing in db
  def create_record(listing)
    #create new record
    if listing['area']
      area_text = listing['area'].downcase
    else
      area_text = ""
    end
    
    area = Area.first_or_create(:location => area_text, :created_at => Time.now)
    listing = Listing.create(
      :title => listing['title'],
      :address => listing['address'],
      :size => listing['size'],
      :price => listing['price'],
      :content => listing['content'],
      :posting_id => listing['posting_id'],
      :url => listing['url'],
      :listing_date => listing['listing_date'],
      :created_at => Time.now
    )
    listing.area = area
    listing.save
    
  end
  
  # parse html content of listing
  def parse_html(listing, url)
    
    debug "Parsing HTML"
    content = (listing/"#userbody").inner_html
    title = (listing/"title").inner_html.strip
    price_br = (listing/"h2").inner_html
    url =~ /(\d+)\.html/
    posting_id = $1
    date = (listing/"body").inner_html
    date =~ /Date: (.+? PDT)/
    date = $1
    price_br =~ /\$(\d+?) \/ (\dbr).+/
    price = $1
    size = $2
    
    street, street1, city, region, area = ""
    street = self.get_cltag(content, "xstreet0")
    
    return if not street 
    
    street1 = self.get_cltag(content, "xstreet1")
    city = self.get_cltag(content, "city")
    region = self.get_cltag(content, "region")
    area = self.get_cltag(content, "GeographicArea")

    street1 = "at #{street1}" if street1
    
    debug "\nFetching new listing... "
    debug "Title:\t#{title}\nPrice:\t$#{price}\nSize:\t#{size}\nStreet:\t#{street}\n"
    debug "City:\t#{city}\nRegion:\t#{region}\nArea:\t#{area}\nDate:\t#{date}\n\n"
    
    return {
      'address' => "#{street} #{street1}, #{city}, #{region}",
      'size' => size,
      'price' => price,
      'title' => title,
      'content' => content,
      'url' => url,
      'posting_id' => posting_id,
      'listing_date' => date,
      'area' => area
    }
    
  end
  
  # for parsing craigslist location tag comments
  def get_cltag(content, type)
    content =~ /<!-- CLTAG #{type}=(.+?) -->/
    if not $1.nil?
      return $1
    end
  end
  
end

# for looping through all listings
class ParseHtmlListings < ParseHtmlListing
  
  # loop through existing 1000 HTML listings
  def go(url)
    (0..1000).step(100) { |i| self.parse(url, i) }
  end
  
  protected
  def parse(url, s=nil)
    debug "S: #{s} URL: #{url}"
    doc = super
    # only culls urls that match base url
    doc.search("a[@href*=#{@@config[@@env]['base_url']}]").each{ |p| 
      self.fetch(p.get_attribute("href"), p.inner_html)
    }
  end
  
end