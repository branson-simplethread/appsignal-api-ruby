require './api'

# API key is available at https://appsignal.com/users/edit
api_key = 'my-personal-api-key'
# "The app_id for an application can be found in the URL of the AppSignal.com when an application is opened"
app_id = 'my-app-id'

api = Appsignal::API.new(api_key)
api.app_id = app_id

errors = api.samples 'errors', exception: 'RuntimeError', limit: 1000
ids = errors['log_entries'].map { |e| e['id'] }
ids.uniq.each do |id|
  sample = api.sample(id)
  puts sample['exception']['message']
end
