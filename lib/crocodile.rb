require 'crocodile/node'
require 'crocodile/selector'
require 'crocodile/simple_selector'
require 'crocodile/sac'
require 'crocodile/crocodile'
require 'crocodile/document'
require 'crocodile/version'
require 'crocodile/rule_set'

def Crocodile string_or_io, encoding = 'UTF-8'
  Crocodile::Document.parse(string_or_io, encoding)
end
