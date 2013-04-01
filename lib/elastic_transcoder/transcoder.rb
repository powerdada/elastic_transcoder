require "elastic_transcoder/transcoder/configuration"
require "elastic_transcoder/authentication"
require "elastic_transcoder/utilities"
require "elastic_transcoder/pipeline"

module ElasticTranscoder

  ##
  # See ElasticTranscoder::Transcoder::Base
  #
  module Transcoder 
    class Base
      include ElasticTranscoder::Transcoder::Configuration
      include ElasticTranscoder::Authentication
    end
  end
end