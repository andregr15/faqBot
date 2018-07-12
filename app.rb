require 'json'
require 'sinatra'
require 'sinatra/activerecord'

require './config/database'

# Loading Models
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./app/services/**/*.rb'].each { |f| require f }

class App < Sinatra::Base
  get '/sinatra' do
    'Hello world!'
  end

  post '/webhook' do
    request.body.rewind
    result = JSON.parse(request.body.read)['queryResult']
    
    if result['contexts'].present?
      response = InterpretService.call(result['action'], result['contexts'][0]['parameters'])
    else
      response = InterpretService.call(result['action'], result['parameters'])
    end
    
    content_type :json 
    {:fulfillmentText => response }.to_json
  end
end