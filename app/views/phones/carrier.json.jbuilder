json.array!(@phones) do |phone|
  json.extract! phone, :id, :name, :shortDescription, :largeImage, :manufacturer, :regularPrice, :bestSellingRank, :salesRankShortTerm, :salesRankMediumTerm, :salesRankLongTerm, :classId
  json.url phone_url(phone, format: :json)
end
