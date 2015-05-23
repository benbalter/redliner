json.array!(@redlines) do |redline|
  json.extract! redline, :id, :key, :user_id, :document_id
  json.url redline_url(redline, format: :json)
end
