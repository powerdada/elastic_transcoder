require "elastic_transcoder/version"

module ElasticTranscoder
  
  def self.configure(&block)
      ElasticTranscoder::Transcoder::Base.configure(&block)
  end
end

require "elastic_transcoder/utilities"
require "elastic_transcoder/pipeline"