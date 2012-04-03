class NrController < ApplicationController
  def index
    logger.info "params: #{params.inspect}"
    render :text => "params: #{params.inspect}"
  end
end
