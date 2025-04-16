module Api
  module V1
    class TasksController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_task, only: [:show, :update, :destroy]

      # GET /api/v1/tasks
      def index
        @tasks = Task.all
        render json: @tasks
      end

      # GET /api/v1/tasks/1
      def show
        render json: @task
      end

      # POST /api/v1/tasks
      def create
        @task = Task.new(task_params)

        if @task.save
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/tasks/1
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tasks/1
      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :completed)
      end
    end
  end
end
