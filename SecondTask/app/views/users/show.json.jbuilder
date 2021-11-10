json.user do
  json.call(
    @user,
    :id,
    :email,
    :name,
    :nickname
  )
end