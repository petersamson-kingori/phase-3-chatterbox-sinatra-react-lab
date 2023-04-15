class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/messages' do
    messages = Message.order(:created_at)
    messages.to_json
  end

  post '/messages' do
    message = Message.new(body: params[:body], username: params[:username])
    if message.save
      message.to_json
    else
      status 400
      { error: "Failed to create message" }.to_json
    end
  end

  patch '/messages/:id' do
    message = Message.find_by(id: params[:id])
    if message
      if message.update(body: params[:body])
        message.to_json
      else
        status 400
        { error: "Failed to update message" }.to_json
      end
    else
      status 404
      { error: "Message not found" }.to_json
    end
  end

  delete '/messages/:id' do
    message = Message.find_by(id: params[:id])
    if message
      message.destroy
      { message: "Message deleted successfully" }.to_json
    else
      status 404
      { error: "Message not found" }.to_json
    end
  end
end

