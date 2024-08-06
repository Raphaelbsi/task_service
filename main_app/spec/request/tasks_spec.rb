require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:tasks) { create_list(:task, 5) }
  let(:valid_attributes) do
    {
      title: 'New Task',
      status: :pending,
      url: 'http://example.com',
      user_id: 1
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      status: nil,
      url: nil,
      user_id: nil
    }
  end

  before do
    authenticate_user
  end

  describe 'GET /tasks' do
    it 'returns a success response' do
      get tasks_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns all tasks' do
      get tasks_path
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  describe 'POST /tasks' do
    context 'with valid params' do
      it 'creates a new Task' do
        Rails.logger.info "Sending POST /tasks with params: #{valid_attributes}"
        expect do
          post tasks_path, params: { task: valid_attributes }
          expect(response).to have_http_status(:created)
        end
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new task' do
        post tasks_path, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let(:new_attributes) do
      {
        title: 'Updated Task',
        status: :completed
      }
    end

    it 'updates the requested task' do
      task = tasks.first
      put task_path(task), params: { task: new_attributes }
      task.reload
      expect(task.title).to eq('Updated Task')
      expect(task.status).to eq('completed')
    end

    it 'renders a JSON response with the task' do
      task = tasks.first
      put task_path(task), params: { task: new_attributes }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['task']['title']).to eq('Updated Task')
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'destroys the requested task' do
      task = tasks.first
      expect do
        delete task_path(task)
      end.to change(Task, :count).by(-1)
    end
  end
end
