class Automobile
  include HerModel

  attributes :year, :make, :model

  # Quick hack to ensure year is an int b/c that's what the golang api expects,
  # it won't serialize a string value for year
  def year
    y = self.attributes[:year]
    if y.present? && y.is_a?(String)
      y = y.to_i
      self.attributes[:year] = y
    end

    y
  end
end
