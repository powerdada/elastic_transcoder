module ElasticTranscoder
  require 'elastic_transcoder/utilities.rb'
  class Pipeline
  
    def initialize
      @utilities = ElasticTranscoder::Utilities.new
    end
    
    def create_pipeline name, input_bucket, output_bucket, role
      action = "pipelines"
      creation_params = '{"Name":"'+name+'","InputBucket":"'+input_bucket+'","OutputBucket":"'+output_bucket+'","Role":"'+role+'","Notifications":{"Progressing":"","Completed":"","Warning":"","Error":"arn:aws:sns:us-east-1:111222333444:ETS_Errors"}}'
      headers = @utilities.initialize_headers action, {:method=>"POST", :payload=>creation_params}
      url = @utilities.build_url action
      response = @utilities.execute_post url, headers, creation_params
    end
    
    def pipeline pipeline_id
      action = "pipelines/#{pipeline_id}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end
   
    def pipelines
      action = "pipelines"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end
    
    def delete_pipeline pipeline_id
      action = "pipelines/#{pipeline_id}"
      headers = @utilities.initialize_headers action, {:method=>"DELETE", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_delete url, headers
    end
  
  end
end

#pipe = ElasticTranscoder::Pipeline.new
#puts pipe.pipelines


