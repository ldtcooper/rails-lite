require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise Exception.new("Double render detected") if already_built_response?
    @res.location = url
    @res.status = 302
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise Exception.new("Double render detected") if already_built_response?
    @res["Content-Type"] = content_type
    @res.write(content)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise Exception.new("Double render detected") if already_built_response?
    path = path_finder(template_name)
    content = File.read(path)
    erb_content = ERB.new(content).result(binding)
    render_content(erb_content, 'text/html')
    @already_built_response = true
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end

  private

  def path_finder(template_name)
    controller_name = self.class.to_s.underscore
    "views/#{controller_name}/#{template_name}.html.erb"
  end
end
