json.extract! reply, :id, :user_id, :tree_id, :stage, :created_at, :updated_at
json.url reply_url(reply, format: :json)