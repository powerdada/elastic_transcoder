require "elastic_transcoder/transcoder/configuration"
require "elastic_transcoder/transcoder/authentication"

module ElasticTranscoder

  ##
  # See ElasticTranscoder::Transcoder::Base
  #
  module Transcoder 
    class Base
      include ElasticTranscoder::Transcoder::Configuration
      include ElasticTranscoder::Transcoder::Authentication
      
      def self.amazon_credentials(value=nil)
          @amazon_credentials = value if value
          return @amazon_credentials
      end
  
      def self.amazon_credentials=(value)
        @amazon_credentials = value
      end
      
    end
  end
end