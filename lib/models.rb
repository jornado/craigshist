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
    property :size,     String
    property :url, String
    property :listing_date, String
    property :created_at, DateTime

    belongs_to :zip_code, :required => false
    belongs_to :area, :required => false

end


# Geocoded zipcode
class ZipCode

  include DataMapper::Resource

  property :id, Serial
  property :zip_code, Integer
  property :lat, String
  property :lng, String
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