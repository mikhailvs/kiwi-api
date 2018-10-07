require 'faraday'
require 'json'
require 'date'

require 'kiwi/wrapped_response'
require 'kiwi/parameter_converter'
require 'kiwi/base'

module Kiwi
  module API
    unless ENV['APP_ENV'] == 'test'
      private_constant :Base
      private_constant :WrappedResponse
      private_constant :ParameterConverter
    end
  end
end

require 'kiwi/api/version'
require 'kiwi/api/locations'
require 'kiwi/api/airlines'
require 'kiwi/api/flights'
