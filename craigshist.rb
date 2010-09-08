require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'dm-core'
require 'dm-timestamps'
require  'dm-migrations'
require 'lib/authorization'

configure :development do
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/craigshist.db")
end

# MODELS

# Individual apt listing
class Listing

    include DataMapper::Resource

    property :id,           Serial
    property :title,        String
    property :content,      Text
    property :address,      String
    property :price,        Integer
    property :posting_id,   Integer
    property :reply_to,     String
    property :listing_date, DateTime

    belongs_to :zip_code, :size

end

# Number of bedrooms
class Size
  
  include DataMapper::Resource
  
  property :id,         Serial
  property :bedrooms,    String
  property :created_at, DateTime
  
  has n, :listing
  
end

# Geocoded zipcode
class ZipCode

  include DataMapper::Resource

  property :id, Serial
  property :zip_code, Integer
  property :created_at, DateTime
  
  has n, :listing
  
end

# Experimental class storing location strings -- might not be useful for anything
class Area

  include DataMapper::Resource

  property :id,           Serial
  property :zip_code,     String
  property :location,     String
  property :created_at,   DateTime

  has n, :listing

end

# CONFIG
configure :development do
  # Create or upgrade all tables
  DataMapper.auto_upgrade!
end

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

helpers do
  include Sinatra::Authorization
  
  def strip_html(string)
    string.gsub(/<.+?>/, '')
  end
  
end

# ROUTES
get '/' do
  erb :index
end

get '/show/:id' do
  require_admin
  @listing = Listing.get(params[:id])
  if @listing
    @page_title = "Listing \#@listing.posting_id"
    erb :show
  else
    redirect('/list')
  end
end

get '/list' do
  require_admin
  @page_title = "Listings"
  @listings = Listing.all(:order => [:created_at.desc])
  erb :list
end
