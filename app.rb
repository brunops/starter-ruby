require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'dotenv'

Dotenv.load

# Load configuration from system environment variables - see the README for more
# on these variables.
TWILIO_ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
TWILIO_AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN']
TWILIO_NUMBER = ENV['TWILIO_NUMBER']

# Create an authenticated client to call Twilio's REST API
client = Twilio::REST::Client.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN

# Sinatra route for your app's home page at "http://localhost:4567/" or your
# public web server
get '/' do
  erb :index
end

# Handle a form POST to send a message
post '/message' do
  # Use the REST API client to send a text message
  client.account.sms.messages.create(
    :from => TWILIO_NUMBER,
    :to => params[:to],
    :body => 'Good luck on your Twilio quest!'
  )

  # Send back a message indicating the text is inbound
  'Message on the way!'
end

# Handle a form POST to make a call
post '/call' do
  # Use the REST API client to make an outbound call
  client.account.calls.create(
    :from => TWILIO_NUMBER,
    :to => params[:to],
    :url => 'http://twimlets.com/message?Message%5B0%5D=http://demo.kevinwhinnery.com/audio/zelda.mp3'
  )

  # Send back a text string with just a "hooray" message
  'Call is inbound!'
end

# Render a TwiML document that will say a message back to the user
get '/hello' do
  # Build a TwiML response
  response = Twilio::TwiML::Response.new do |r|
    r.Say 'Hello there! You have successfully configured a web hook.'
    r.Say 'Good luck on your Twilio quest!', :voice => 'woman'
  end

  # Render an XML (TwiML) document
  content_type 'text/xml'
  response.text
end

# Render a TwiML document that will say a message back to the user
get '/hello-sms' do
  # Build a TwiML response
  response = Twilio::TwiML::Response.new do |r|
    r.Sms 'Hello there! You have successfully configured a web hook.'
    r.Sms 'Good luck on your Twilio quest!', :voice => 'woman'
  end

  # Render an XML (TwiML) document
  content_type 'text/xml'
  response.text
end

post '/voicemail' do
  p params
  response = Twilio::TwiML::Response.new do |r|

    if params[:Digits]
      r.Say "You entered: #{params[:Digits]}"
    else
      r.Gather numDigits: 1 do
        r.Say "Thanks for calling bla bla"
        r.Say "Pess 1 to leave a message."
        r.Say "Pess 2 to listen to the last messages"
      end
    end
  end

  content_type 'text/xml'
  response.text
end




