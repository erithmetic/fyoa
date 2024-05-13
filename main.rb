require 'bundler/setup'

require 'json'
require 'rqrcode'
require 'sinatra'
require 'prawn'

DEBUG = ENV['DEBUG'] == 'true' ? true : false

class StoryNotFound < Exception; end

def fax_pdf(id)

end

get '/story/:id' do
  id = params.fetch('id')

  @story = gopher[params['id']]
  raise StoryNotFound, 'you are on the wrong path!' if @story.nil?

  fax_pdf id, params[:n]

  erb :story
end