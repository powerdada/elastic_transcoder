require "elastic_transcoder/version"
require "elastic_transcoder/transcoder"

module ElasticTranscoder
  
  def self.configure(&block)
      #ElasticTranscoder::Transcoder::Base.new.configure(&block)
      ElasticTranscoder::Transcoder::Base.amazon_credentials(&block)
  end
end

require "elastic_transcoder/utilities"
require "elastic_transcoder/pipeline"
require "elastic_transcoder/jobs"