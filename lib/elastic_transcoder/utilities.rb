require 'httparty'
require 'elastic_transcoder/transcoder/authentication'
require 'elastic_transcoder/transcoder'
module ElasticTranscoder
  class Utilities
    @@api_version = "2012-09-25"
    @@host = "elastictranscoder.us-east-1.amazonaws.com"

  
    #options could be [method, payload]
    def initialize_headers action, options = {}
      amz_credentials = ElasticTranscoder::Transcoder::Base.amazon_credentials
      authorization, date = ElasticTranscoder::Transcoder::Authentication.build_authorization amz_credentials[:aws_access_key_id], amz_credentials[:aws_secret_access_key], @@host, options[:method], action, "2012-09-25", {}, options[:payload]
      headers = {"Authorization"=> authorization,
                  "x-amz-date"=>date,
                  "Content-Length"=>"#{options[:payload].size}"}
      return headers
    end
    
    def build_url action
      "https://#{@@host}/#{@@api_version}/#{action}"
    end
    
    def execute_get url, headers
      HTTParty.get url, :headers=>headers
    end
    def execute_post url, headers, body
      HTTParty.post url, :body=>body, :headers=>headers
    end
    
    def execute_delete url, headers
      HTTParty.delete url, :headers=>headers
    end
  end
end