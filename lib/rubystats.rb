module Rubystats
  VERSION = '0.2.3'
end

require './lib/rubystats/normal_distribution'
require './lib/rubystats/binomial_distribution'
require './lib/rubystats/beta_distribution'
require './lib/rubystats/fishers_exact_test'
require './lib/rubystats/exponential_distribution'
include Rubystats
