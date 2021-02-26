require 'pp'

class ApplicationController < ActionController::Base

  def authenticate
    authenticate_or_request_with_http_basic("Administration") do |user,pass| user == 'admin' && pass = 'secret' end 
  end

end
