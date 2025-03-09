class RedirectionsController < ApplicationController
  def create
    process_usecase(::Redirections::Create, request: request) { |result|
      render json: result[:redirection], status: :created
    }
  end

  def show
    process_usecase(::Redirections::Show, request: request) { |result|
      redirect_to result[:redirection].target_url, allow_other_host: true
    }
  end

  def destroy
    process_usecase(::Redirections::Destroy, request: request) { |_result| head :no_content }
  end

  def history
    process_usecase(::Redirections::History, request: request) { |result|
      render json: result[:requisitions], status: :ok
    }
  end
end
