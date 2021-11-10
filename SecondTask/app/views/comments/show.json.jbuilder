json.card do
  json.id @comment.id
  json.tile @comment.commenter
  json.description @comment.body
  json.card @card.title
  json.column @column.title
  json.owner @user.email
end
