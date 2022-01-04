require 'net/http'
require 'json'

# https://docs.appsignal.com/api

module Appsignal
  class API
    attr_accessor :app_id
    attr_reader :api_key

    # API key is available at https://appsignal.com/users/edit
    def initialize(api_key)
      @api_key = api_key
    end

    def endpoint_uri(endpoint, params: {})
      raise "no app_id set" if app_id.nil?
      params[:token] = api_key
      params_s = URI.encode_www_form(params.compact)
      URI("https://appsignal.com/api/#{app_id}/#{endpoint}.json?#{params_s}")
    end

    # https://docs.appsignal.com/api/samples.html
    def samples(
      type = nil,
      action_id: nil, exception: nil,
      since: nil, before: nil,
      limit: nil, count_only: nil
    )
      if action_id.is_a? String
        action_id.gsub!("#", "-hash-")
        action_id.gsub!("/", "-slash-")
        action_id.gsub!(".", "-dot-")
      end

      results = Net::HTTP.get(
        endpoint_uri(
          ["samples", type].compact.join("/"),
          params: {
            action_id: action_id, exception: exception,
            since: since, before: before,
            limit: limit, count_only: count_only
          }
        )
      )
      JSON.parse(results)
    end

    def sample(id)
      result = Net::HTTP.get(endpoint_uri("samples/#{id}"))
      JSON.parse(result)
    end
  end
end
