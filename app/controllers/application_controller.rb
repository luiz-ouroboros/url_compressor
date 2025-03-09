class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def process_usecase(usecase, custom_params: params.to_unsafe_h, **args)
    usecase.call(params: custom_params, **args)
      .on_success { |result| yield(result) }
      .on_failure(:validation_error) { |result| render json: result, status: :unprocessable_entity }
  end

  def record_not_found(exception)
    render json: { error: [I18n.t('errors.not_found')] }, status: :not_found
  end
end
