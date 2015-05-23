json.array!(@users) do |user|
  json.extract! user, :id, :login, :name, :admin
  json.url user_url(user, format: :json)
end
