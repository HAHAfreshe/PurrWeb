json.card do
  json.id @card.id
  json.tile @card.title
  json.description @card.description
  json.column @column.title
  json.owner @user.email
end
