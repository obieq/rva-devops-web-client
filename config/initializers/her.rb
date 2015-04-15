# first, verify that the rva devops api endpoint environment variable has been set
rva_devops_api_endpoint = ENV['RVA_DEVOPS_API_ENDPOINT']
raise 'rva devops api endpoint cannot be blank' unless rva_devops_api_endpoint

RVA_DEVOPS_API = Her::API.new

class MyCustomerParser < Faraday::Response::Middleware
  def on_complete(env)
    body = env[:body]
    json = {}

    if body && body.length > 0
      json = MultiJson.load(env[:body], symbolize_keys: true)
    end

    # convert all dasherized keys to underscored keys
    data = JsonApiHelper.underscore_keys(json)

    env[:body] = {
      data: data || {},
      errors: json[:errors] || {}, # NOTE: if no errors, then set to empty hash... otherwise Her.Save breaks
      metadata: json[:metadata] || {}
    }
  end
end

RVA_DEVOPS_API.setup url: rva_devops_api_endpoint do |c|
  # Request
  c.use RvaDevopsFaradayMiddleware

  # Response
  c.use MyCustomerParser

  # Adapter
  c.use Faraday::Adapter::NetHttp
end
