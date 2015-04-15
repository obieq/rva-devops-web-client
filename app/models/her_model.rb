module HerModel
  extend ActiveSupport::Concern

  included do
    include Her::Model

    use_api RVA_DEVOPS_API

    attributes :created_at

    # Her::Model doesn't have an update method, which rails scaffolded controllers expect
    def update(params)
      self.assign_attributes(params)

      return self.save
    end

    # override default errors behavior to include server-side errors (JSON API format)
    def errors
      errorz = super
      if errorz.count == 0
        _process_json_api_errors
        errorz = super
      end

      return errorz
    end

    private
    def _process_json_api_errors
      errorz = self.response_errors || {}
      raise "api errors should be a hash for now! (will be an array at some point?)" unless errorz.kind_of? Hash

      errorz.keys.each do |k|
        self.instance_variable_get('@errors').add(k, errorz[k])
      end
    end
  end # included do

end # module HerModel
