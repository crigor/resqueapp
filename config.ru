# This file is used by Rack-based servers to start the application.

fail!
require ::File.expand_path('../config/environment',  __FILE__)
#run Resqueapp::Application
require 'resque/server'

run Rack::URLMap.new \
  "/"       => Resqueapp::Application,
  "/resque" => Resque::Server.new
