require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  describe "GET /api/v1/tasks" do
    before do
      create_list(:task, 3)
    end

    it "returns all tasks" do
      get api_v1_tasks_path
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /api/v1/tasks/:id" do
    let(:task) { create(:task) }

    it "returns a specific task" do
      get api_v1_task_path(task)
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["id"]).to eq(task.id)
    end
  end

  describe "POST /api/v1/tasks" do
    let(:valid_attributes) { { task: { title: "New Task", description: "Task description", completed: false } } }
    let(:invalid_attributes) { { task: { title: "", description: "Task description", completed: false } } }

    context "with valid parameters" do
      it "creates a new task" do
        expect {
          post api_v1_tasks_path, params: valid_attributes
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["title"]).to eq("New Task")
      end
    end

    context "with invalid parameters" do
      it "does not create a new task" do
        expect {
          post api_v1_tasks_path, params: invalid_attributes
        }.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    let(:task) { create(:task) }
    let(:valid_attributes) { { task: { title: "Updated Task" } } }
    let(:invalid_attributes) { { task: { title: "" } } }

    context "with valid parameters" do
      it "updates the requested task" do
        patch api_v1_task_path(task), params: valid_attributes
        task.reload

        expect(response).to have_http_status(:success)
        expect(task.title).to eq("Updated Task")
      end
    end

    context "with invalid parameters" do
      it "does not update the task" do
        patch api_v1_task_path(task), params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    let!(:task) { create(:task) }

    it "destroys the requested task" do
      expect {
        delete api_v1_task_path(task)
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
