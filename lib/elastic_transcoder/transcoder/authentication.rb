module ElasticTranscoder
  module Transcoder
  require 'cgi'
  require 'openssl'
  require "base64"
  require 'digest'
  require "time"
    module Authentication
      @@digest1 = OpenSSL::Digest::Digest.new("sha1")
      @@digest256 = nil
      if OpenSSL::OPENSSL_VERSION_NUMBER > 0x00908000
        @@digest256 = OpenSSL::Digest::Digest.new("sha256") rescue nil # Some installation may not support sha256
      end
      
      # Set a timestamp and a signature version
      def self.format_service_params(service_hash, signature)
        service_hash["Timestamp"] ||= Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z") unless service_hash["Expires"]
        service_hash["SignatureVersion"] = signature
        service_hash
      end
      
      def self.escape_val(val)
        CGI.escape(val)
      end
      
      def self.amz_escape(param)
        param = param.to_s
        escaped = escape_val(param)
        #escaped = escaped.gsub("~","%7E")
        escaped = escaped.gsub("+", "%20")
        escaped = escaped.gsub("*", "%2A")
        escaped
      end
      
      def self.full_date date
        "Mon, 09 Sep 2011 23:36:00 GMT"
      end
      
      def self.amz_date date
        date.strftime("%Y-%m-%dT%H:%M:%SZ")
      end
      def self.x_amz_date date
        date.strftime("%Y%m%dT%H%M%SZ")
      end
      
      def self.normal_date date
        date.strftime("%Y%m%d")
      end
      
      def self.generate_service_hash aws_access_key, action, date, api_version, algorithm, signature
        service_hash = {"Action" => action,
                        "AWSAccessKeyId" => aws_access_key}
        service_hash.update("Version" => api_version) if api_version
        service_hash.update("X-Amz-Algorithm" => algorithm)
        service_hash.update("X-Amz-Credential" => "#{aws_access_key}/20120925/us-east-1/elastictranscoder/aws4_request")
        service_hash.update("X-Amz-Date" => (amz_date date.iso8601))
        service_hash.update("X-Amz-SignedHeaders" => "content-type;host;x-amz-date") # ???
        service_hash.update("X-Amz-Signature" => signature)
        service_hash
        #service_hash.update(user_params)
      end
      
      def self.generate_canonical_string params_hash
        canonical_string = params_hash.keys.sort.map do |key|
          "#{amz_escape(key)}=#{amz_escape(params_hash[key])}" #unless key=="X-Amz-Signature"
        end.join('&')
        canonical_string
      end
      
      def self.sign_request_v3 aws_secret_key, date
        algorithm =  @@digest256 ? 'HmacSHA256' : 'HmacSHA1'
        # Select a digest
        digest = (algorithm == 'HmacSHA256' ? @@digest256 : @@digest1)
        signature = (Base64.encode64(OpenSSL::HMAC.digest(digest, aws_secret_key, date.httpdate)).strip)
        return signature, algorithm
      end
      
      def self.prepare_query_string host, canonical_string
        "https://#{host}/?#{canonical_string}"
      end
      
      def self.generate_signed_request aws_access_key, aws_secret_key, action, api_version, host
        date = Time.now.getutc
        signature, algorithm = sign_request_v3(aws_secret_key, date)
        service_hash = generate_service_hash aws_access_key, action, date, api_version, algorithm, signature
        canonical_string = generate_canonical_string service_hash
        #headers = {}
        #headers['X-Amzn-Credential'] = "AWS3-HTTPS AWSAccessKeyId=#{aws_access_key}, Algorithm=#{algorithm.upcase}, Signature=#{signature}"
        #headers['Date'] = date.httpdate
        prepare_query_string host, canonical_string
      end
      
      ############################
      
      def self.hash_value value
        sha256 = Digest::SHA256.new
        sha256.digest value
      end
      
      def self.hmac key, value
        OpenSSL::HMAC.digest(@@digest256, key, value)
      end
      
      def self.hex_encode value
        #OpenSSL::HMAC.hexdigest(@@digest256, key, value)
        Digest.hexencode value
      end
      
      def self.generate_query_string action, api_version, user_params
        query_string = {}
        #query_string = {"Action" => action,
        #                "Version" => api_version}
        if user_params
          user_params.each do |key, value|
            query_string.update(key=>value)
          end
        end
        
        return generate_canonical_string query_string
      end
      def self.generate_canonical_header host, date
        canonical_header = "host:#{host}\nx-amz-date:#{amz_date date}"
      end
      
      def self.sign_payload payload
        hex_encode hash_value(payload)
      end
      
      def self.generate_canonical_request aws_secret_key, method, host, uri, date, query_string, payload
        canonical_request = "#{method}\n#{uri}\n#{query_string}\n#{generate_canonical_header host, date}\n\nhost;x-amz-date\n#{sign_payload payload}"
      end
      
      def self.credential_scope date, region
        "#{normal_date date}/#{region}/elastictranscoder/aws4_request"
        #"20110909/us-east-1/host/aws4_request"
      end
      
      def self.generate_string_to_sign date, canonical_request_hash, region
        "AWS4-HMAC-SHA256\n#{x_amz_date date.gmtime}\n#{credential_scope date, region}\n#{canonical_request_hash}"
      end
      
      def self.generate_derived_signing_key aws_secret_key, date, region
        hmac(hmac(hmac(hmac("AWS4" + aws_secret_key,(normal_date date.gmtime)),region),"elastictranscoder"),"aws4_request")
        #hmac(hmac(hmac(hmac("AWS4" + aws_secret_key,(normal_date date)),region),"host"),"aws4_request")
      end
      
      def self.generate_signature derived_signing_key, string_to_sign
        hex_encode(hmac(derived_signing_key, string_to_sign))
      end
      
      def self.sign_request_v4 aws_access_key, aws_secret_key, host, method, action, api_version, user_params, date, region, payload
        #Step1
        #query_string = "foo=Zoo&"+(generate_query_string action, api_version, user_params)
        query_string = generate_query_string action, api_version, user_params
        #puts "query_string: #{query_string}\n\n"
        canonical_request = generate_canonical_request aws_secret_key, method, host, "/#{api_version}/#{action}", date, query_string, payload
        puts "canonical_request: #{canonical_request}\n\n"
        canonical_request_hash = hex_encode hash_value(canonical_request)
        puts "canonical_request_hash: #{canonical_request_hash}\n\n"
        
        #Step2
        string_to_sign = generate_string_to_sign date, canonical_request_hash, region
        puts "string_to_sign: #{string_to_sign}\n\n"
        
        #Step3
        derived_signing_key = generate_derived_signing_key aws_secret_key, date, region
        #puts "derived_signing_key: #{derived_signing_key}\n\n"
        signature = generate_signature derived_signing_key, string_to_sign
        #puts "signature: #{signature}\n\n"
      end
      
      def self.build_authorization aws_access_key, aws_secret_key, host, method, action, api_version, user_params, payload
         date = Time.now.getutc
         region = "us-east-1"
         signature = sign_request_v4 aws_access_key, aws_secret_key, host, method, action, api_version, user_params, date, region, payload
        return "AWS4-HMAC-SHA256 Credential=#{aws_access_key}/#{normal_date date}/#{region}/elastictranscoder/aws4_request, SignedHeaders=host;x-amz-date, Signature=#{signature}", date.iso8601
      end
    
    end
  end
end

#puts ElasticTranscoder::Authentication.build_authorization "access_key", "secret_key", "elastictranscoder.us-east-1.amazonaws.com", "GET", "pipelines", "2012-09-25", {}
