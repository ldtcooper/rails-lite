require 'rack'
app = Proc.new do |env|
  req = Rack::Request.new(env) #creates new request based off of what is passed into #call
  res = Rack::Response.new #creates new resonse object (like a hash)
  res['Content Type'] = 'text/html' # sets the content carried by response to html
  res.write("#{req.path}") # writes content to response
  res.finish # ends the response
end

Rack::Server.start(app: app, Port: 3000)
