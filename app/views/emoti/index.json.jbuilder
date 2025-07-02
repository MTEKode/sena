json.array! @emotis do |emoti|
  json.extract! emoti, :id, :name
  json.image_url image_url("emotis/#{emoti.key}.png")
  json.chat_link chat_url(emoti.id)
end