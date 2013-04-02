module ElasticTranscoder

  module Transcoder
    module Configuration
        def configure
          yield self
        end
      
        def self.amazon_credentials(value=nil)
          @amazon_credentials = value if value
          return @amazon_credentials
        end
  
        def self.amazon_credentials=(value)
          @amazon_credentials = value
        end
  
        def amazon_credentials=(value)
          @amazon_credentials = value
        end
  
        def amazon_credentials
          @amazon_credentials
        end 
      end
  end
end