module JsonApiHelper

  def self.underscore_keys(json)
    data = json[:data]

    # convert all dasherized keys to underscored keys
    if data.instance_of? Array
      data = []
      json[:data].each do |resource|
        hash = {}
        resource.map {|k, v| hash[k.to_s.underscore.to_sym] = resource[k]}
        data << hash
      end
    elsif data
      data = {}
      resource = json[:data]
      resource.map{|k,v| data[k.to_s.underscore.to_sym] = resource[k]}
    end

    return data
  end # self.underscore_keys

  def self.dasherize_keys(json)
    dasherizedJson = {}
    json.map {|k, v| dasherizedJson[k.to_s.dasherize.to_sym] = json[k]}

    return {data: dasherizedJson}
  end # self.dasherize_keys

end # module JsonApiHelper
