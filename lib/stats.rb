require './lib/chdebug'
require './lib/rubystats/normal_distribution'

module Enumerable
	  def to_histogram
	    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
	  end
end

class Stats < CHDebug
  
  def histogram(pop, num=1000)
    vals = self.normalize(pop, num)
    hist = vals.to_histogram
    pairs = hist.keys.collect { |x| [x.to_s, hist[x]] }.sort
  end

  def normalize(pop, num=1000)
    # Normalize array of numbers 
		sigma = self.std(pop)
		mu = self.mean(pop)

    norm = Rubystats::NormalDistribution.new(mu, sigma)
		normed_pop = Array.new
    num.times do 
      normed_pop.push norm.rng.to_int
    end
    
    normed_pop
  end
  
  def mean(pop)
    (pop.size > 0) ? self.sum(pop) / pop.size : 0
  end

  def sum(pop)
    pop.inject(0){|sum,item| sum + item}
  end
  
  # borrowed from http://warrenseen.com/blog/2006/03/13/how-to-calculate-standard-deviation/
  def variance(population)
      n = 0
      mean = 0.0
      s = 0.0
      population.each { |x|
        n = n + 1
        delta = x - mean
        mean = mean + (delta / n)
        s = s + delta * (x - mean)
      }
      # if you want to calculate std deviation
      # of a sample change this to "s / (n-1)"
      return s / n
    end

    # calculate the standard deviation of a population
    # accepts: an array, the population
    # returns: the standard deviation
    def std(population)
      Math.sqrt(variance(population))
    end
  
end