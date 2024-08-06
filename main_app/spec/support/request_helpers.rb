module RequestHelpers
  def authenticate_user
    allow_any_instance_of(TasksController).to receive(:authenticate_user).and_return(true)
    allow_any_instance_of(TasksController).to receive(:instance_variable_get).with(:@current_user_id).and_return(1)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
