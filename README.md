# ElasticTranscoder

This gem is intended to manage the elastic transcoder services of Amazon Web Services

## Installation

Add this line to your application's Gemfile:

    gem 'elastic_transcoder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elastic_transcoder

## Usage

First thing to do is to create an rails initilizer with your amazon credentials(initializers/elastic_transcoder.rb):

	ElasticTranscoder::Transcoder::Base.amazon_credentials = {
    	:provider               => 'AWS',       # required
    	:aws_access_key_id      => 'YOUR_AMAZON_ACCESS_KEY',       # required
    	:aws_secret_access_key  => 'YOUR_AMAZON_SECRET_KEY',       # required
    	:region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
	}

After that, you can start using your transcoder

Creating the pipeline object:

	pipeline_front = ElasticTranscoder::Pipeline.new
	
Creating a pipeline:

	pipeline_front.create_pipeline "Pipeline_name", "input_amazon_s3_bucket", "output_amazon_s3_bucket", "default_role"
	
Deleting a Pipeline:

	pipeline_front.delete_pipeline "pipeline_id"

Listing all pipelines:

	pipeline_front.pipelines
	
Getting a specific pipeline:

	pipeline_front.pipeline "pipeline_id"
	
	
Now for job creation

Creating the job object:

	jobs_front = ElasticTranscoder::Jobs.new
	
Creating a job:

	jobs_front.create_job "input_id", "output_id", "pipeline_id", "preset_id", "thumbnails_pattern"
	Example: jobs_front.create_job "videos/my_vid.mov", "videos/encoded_vid.mov", "1364228226277-089c00", "1351620000000-000020", "videos/thumbnail-{count}"
	
Deleting a job:

	jobs_front.delete_job "job_id"
	
Getting jobs by pipeline:

	jobs_front.jobs_by_pipeline "pipeline_id"
	
Getting jobs by status (possible statuses [Submitted|Progressing|Complete|Canceled|Error]):

	jobs_front.jobs_by_status "status"
	
Getting a specific job:

	jobs_front.job "job_id"

	
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======
elastic_transcoder
==================

Amazon Elastic Transcoder frontend
