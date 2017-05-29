json.extract! video, :id, :url, :name, :course_id, :final_url, :created_at, :updated_at
json.url video_url(video, format: :json)