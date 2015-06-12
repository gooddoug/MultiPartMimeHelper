# test_app.rb
# This is a simple web service that accepts a multipart file for testing
# gem install sinatra; gem install haml
# ruby test_app.rb

require 'sinatra'
require 'haml'

get '/' do
	haml '%form{:action=>"/upload",:method=>"post"   ,:enctype=>"multipart/form-data"}
  %input{:type=>"file",:name=>"file"}
  %input{:type=>"submit",:value=>"Upload"}'
end

post '/upload' do
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    @error = "No file selected"
    return haml(:upload)
  end
  STDERR.puts "Uploading file, original name #{name.inspect}"
  while blk = tmpfile.read(65536)
    # here you would write it to its final location
    STDERR.puts blk.inspect
  end
  "Upload complete"
end