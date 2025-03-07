class ApplicationController < ActionController::API
  private

  def process_usecase(usecase, custom_params: params.to_unsafe_h)
    usecase.call(params: custom_params)
      .on_success { |result| yield(result) }
      .on_failure(:validation_error) { |result| render json: result, status: :unprocessable_entity }
  end
end
