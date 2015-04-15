json.array!(@automobiles) do |automobile|
  json.extract! automobile, :id, :year, :make, :model
  json.url automobile_url(automobile, format: :json)
end
