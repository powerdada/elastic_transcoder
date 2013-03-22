module ElasticTranscoder
  require 'httparty'
  load 'authentication.rb'
  class Utilities
    @@api_version = "2012-09-25"
    @@host = "elastictranscoder.us-east-1.amazonaws.com"

  
    #options could be [method, payload]
    def initialize_headers action, options = {}
      authorization, date = ElasticTranscoder::Authentication.build_authorization "access_key", "secret_key", @@host, options[:method], action, "2012-09-25", {}, options[:payload]
      headers = {"Authorization"=> authorization,
                  "x-amz-date"=>date}
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