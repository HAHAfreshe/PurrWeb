json.column do
  json.id @column.id
  json.tile @column.title
  json.description @column.description
  json.owner @user.email
end
