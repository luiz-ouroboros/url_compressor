class RedirectionsController < ApplicationController
  def create
    process_usecase(::Redirections::Create, request: request) { |result|
      render json: result[:redirection], status: :created
    }
  end
end
