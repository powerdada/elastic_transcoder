module ElasticTranscoder
  load 'utilities.rb'
  class Jobs
  
    def initialize
      @utilities = ElasticTranscoder::Utilities.new
    end
   
    def jobs_by_pipeline pipeline_id
      action = "jobsByPipeline/#{pipeline_id}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end
    
    #Valid statuses [Submitted|Progressing|Complete|Canceled|Error"]
    def jobs_by_status status
      action = "jobsByStatus/#{status}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end
    
    def job job_id
      action = "jobs/#{job_id}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end
    
    def delete_job job_id
      action = "jobs/#{job_id}"
      headers = @utilities.initialize_headers action, {:method=>"DELETE", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_delete url, headers
    end
  
  end
end

job = ElasticTranscoder::Jobs.new
puts job.jobs_by_pipeline "1363791455355-d92773"
puts job.jobs_by_status "Complete"
puts job.job "1363791455355-d92773" #fake job number
puts job.delete_job "1363791455355-d92773" #fake job number
