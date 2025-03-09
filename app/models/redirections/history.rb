class Redirections::History < UseCase
  attributes :params, :request

  class UseContract < ContractScheme
    params do
      required(:secret_key).filled(:string)
    end
  end

  def call!
    transaction {
      validate_params(UseContract, params)
      .then(apply(:find_redirection))
      .then(apply(:create_requisition))
    }.then(apply(:output))
  end

  private

  def find_redirection(params:, **)
    redirection = Redirection.find_by!(secret_key: params[:secret_key])

    Success(:find_redirection_success, result: { redirection: redirection })
  end

  def create_requisition(redirection:, **)
    call(::Requisitions::Create, redirection: redirection, action_type: 'history')
  end

  def output(redirection:, **)
    Success(:history_success, result: { redirection: redirection, requisitions: redirection.requisitions })
  end
end
