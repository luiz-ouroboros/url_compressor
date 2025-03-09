class Redirections::Show < UseCase
  attributes :params, :request

  class UseContract < ContractScheme
    params do
      required(:target_key).filled(:string)
    end
  end

  def call!
    transaction {
      validate_params(UseContract, params)
      .then(apply(:find_redirection))
      .then(apply(:increment_redirection_count))
      .then(apply(:create_requisition))
    }.then(apply(:output))
  end

  private

  def find_redirection(params:, **)
    redirection = Redirection.find_by!(target_key: params[:target_key], expire_at: [nil, Time.zone.today..])

    Success(:find_redirection_success, result: { redirection: redirection })
  end

  def increment_redirection_count(redirection:, **)
    redirection.increment!(:requisition_count)

    Success(:increment_redirection_count_success, result: { redirection: redirection })
  end

  def create_requisition(redirection:, **)
    call(::Requisitions::Create, redirection: redirection, action_type: 'show')
  end

  def output(redirection:, **)
    Success(:show_success, result: { redirection: redirection })
  end
end
