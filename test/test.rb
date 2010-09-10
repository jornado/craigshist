require 'craigshist'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'lib/stats'

class CHMathTest < Test::Unit::TestCase
  def setup
    @prices = [750, 850, 950]
    @stat = Stats.new
    @stat.init
  end

  def test_sum
    assert_equal(2550, @stat.sum(@prices))
  end
  
  def test_mean
    assert_equal(850, @stat.mean(@prices))
  end
  
  def test_normalize
    #norm = @stat.normalize(@prices)
    
    #puts norm
  end
  
  def test_histogram
    puts @stat.to_histogram(@prices)
    
  end
  
end

class CHModels < Test::Unit::TestCase

  def test_listings
    @listings = Listing.all()
    assert(true, @listings.count)
  end
  
  def test_zips
    @zips = ZipCode.all()
    assert(true, @zips.count)
  end
  
end

Test::Unit::UI::Console::TestRunner.run(CHMathTest)
Test::Unit::UI::Console::TestRunner.run(CHModels)

