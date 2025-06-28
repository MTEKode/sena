require 'http'
require 'json'

module ChatApi
  module Gpt
    class Client
      def initialize
        @api_key = ENV['GPT_KEY']
        raise ArgumentError, 'API key is required' unless @api_key
      end

      protected

      def send_request(request_body)
        response = HTTP.headers(
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{@api_key}"
        ).post(
          'https://api.openai.com/v1/chat/completions',
          body: request_body.to_json
        )

        if response.status.success?
          parsed_response = JSON.parse(response.body.to_s)
          parsed_response['choices'][0]['message']['content']
        else
          { error: response.body.to_s }
        end
      rescue HTTP::Error => e
        { error: e.message }
      end
    end
  end
end