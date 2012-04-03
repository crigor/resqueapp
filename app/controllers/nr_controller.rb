class NrController < ApplicationController
  def index
    render :text => "params: #{params.inspect}"
  end
end
