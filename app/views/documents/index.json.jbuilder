json.array!(@documents) do |document|
  json.extract! document, :id, :repository_id, :path
  json.url document_url(document, format: :json)
end
