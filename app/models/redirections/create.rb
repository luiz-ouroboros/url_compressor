class Redirections::Create < UseCase
  attributes :params, :request

  class UseContract < ContractScheme
    params do
      required(:target_url).filled(::Types::URL)
      optional(:expire_at).maybe(:date)
    end
  end

  def call!
    transaction {
      validate_params(UseContract, params)
      .then(apply(:validate_self_target_url))
      .then(apply(:validate_target_url_unique))
      .then(apply(:validate_expire_at))
      .then(apply(:build_and_save_redirection))
      .then(apply(:create_requisition))
    }.then(apply(:output))
  end

  private

  def validate_self_target_url(params:, **)
    if params[:target_url].include?(Redirection::APP_HOST)
      return Failure(:validation_error, result: build_error(:target_url, 'errors.redirection.self_target_url'))
    end

    Success(:validate_self_target_url_success)
  end

  def validate_target_url_unique(params:, **)
    if Redirection.exists?(target_url: params[:target_url])
      return Failure(:validation_error, result: build_error(:target_url, 'errors.redirection.target_url_already_exists'))
    end

    Success(:validate_target_url_unique_success)
  end

  def validate_expire_at(params:, **)
    if params[:expire_at] && params[:expire_at] < Time.zone.today
      return Failure(:validation_error, result: build_error(:expire_at, 'errors.redirection.expire_at_is_passed'))
    end

    Success(:validate_expire_at_success)
  end

  def build_and_save_redirection(params:, **)
    redirection = Redirection.new(params)
    redirection.generate_secret_key
    redirection.generate_target_key

    redirection.save!

    Success(:build_and_save_redirection_success, result: { redirection: redirection })
  end

  def create_requisition(redirection:, **)
    call(::Requisitions::Create, redirection: redirection, action_type: 'create')
  end

  def output(redirection:, **)
    Success(:create_success, result: { redirection: redirection })
  end
end
