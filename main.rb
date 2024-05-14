require 'bundler/setup'

require 'json'
require 'sinatra'
require 'twilio-ruby'

DEBUG = ENV['DEBUG'] == 'true' ? true : false
ACCOUNT_SID = ENV.fetch 'ACCOUNT_SID'
AUTH_TOKEN = ENV.fetch 'AUTH_TOKEN'
NOTIFICATION_SMS_NUMBER = ENV.fetch 'NOTIFICATION_SMS_NUMBER'
TWILIO_SMS_NUMBER = ENV.fetch 'TWILIO_SMS_NUMBER'

class StoryNotFound < Exception; end

gopher = JSON.parse(File.read('gopher.json'))

def fax_pdf(id, number)
  # twilio = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
  # message = twilio.messages.create(
  #   body: "#{number} chose #{id}",
  #   to: NOTIFICATION_SMS_NUMBER,  # Text this number
  #   from: TWILIO_SMS_NUMBER, # From a valid Twilio number
  # )
  logger.info "#{number} chose #{id}"
end

use Rack::Logger

helpers do
  def logger
    request.logger
  end
end

get '/story/:id/:number' do
  id = params.fetch('id')

  @story = gopher[params['id']]
  raise StoryNotFound, 'you are on the wrong path!' if @story.nil?

  fax_pdf id, params[:number]

  erb :story
end