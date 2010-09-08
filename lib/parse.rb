require 'rubygems'
require "hpricot"
require "open-uri"

class Parse

  def open_url(url)
    @url = url
    Hpricot(open(@url))
  end
  
  def parse(url)
    @doc = self.open_url(url)
    puts @doc
  end
  
end

class ParseHtmlListing < Parse

end

class ParseHtmlListings < ParseHtmlListing
  
end