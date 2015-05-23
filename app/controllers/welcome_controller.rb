class WelcomeController < ApplicationController
  def index
    puts client.inspect
  end
end
