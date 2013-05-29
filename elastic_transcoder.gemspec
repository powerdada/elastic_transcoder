# -*- encoding: utf-8 -*-
require File.expand_path('../lib/elastic_transcoder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ronald05arias"]
  gem.email         = ["ronald05arias@gmail.com"]
  gem.description   = %q{This gem is intended to manage the elastic transcoder services of Amazon Web Services}
  gem.summary       = %q{Frontend for Amazon Elastic Transcoding }
  gem.homepage      = "https://github.com/ronald05arias/elastic_transcoder"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "elastic_transcoder"
  gem.require_paths = ["lib"]
  gem.version       = ElasticTranscoder::VERSION
  
  gem.add_dependency "httparty"
  gem.add_dependency "multi_json"
  gem.add_dependency "multi_xml"
end
