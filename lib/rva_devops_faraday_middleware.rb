class RvaDevopsFaradayMiddleware < Faraday::Middleware
  def call(request_env)
    # set content type and accept  to json for ALL requests
    request_env[:request_headers]["Content-Type"] = "application/json"
    request_env[:request_headers]["Accept"] = "application/json"

    request_env[:request_headers]["Authorization"] = "rva_devops_auth_token"

    # dasherize path
    request_env.url.path = request_env.url.path.dasherize

    if [:post, :put, :delete].include?(request_env.method)
      # NOTE: for true JSON API, we need to send a root key called "data" for create, update, and delete
      json = MultiJson.load(request_env.body.to_json, symbolize_keys: false)

      # dasherize keys and convert to stringified json
      request_env.body = JsonApiHelper.dasherize_keys(json).to_json
    end

    @app.call(request_env).on_complete do |response_env|
      #byebug
    end
  end
end
