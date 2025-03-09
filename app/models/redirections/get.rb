class Redirections::Get < UseCase
  attributes :params

  class UseContract < ContractScheme
    params do
      optional(:search).maybe(:string)
      optional(:id).maybe(:integer)
      optional(:remote_ip).maybe(:string)
      optional(:action_type).maybe(:string)
    end
  end

  def call!
    validate_params(UseContract, params)
      .then(:load_redirections)
      .then(:includes)
      .then(:filter_by_id)
      .then(:filter_by_remote_ip)
      .then(:filter_by_action_type)
      .then(:search)
      .then(:order)
      .then(:output)
  end

  private

  def load_redirections(params:, **)
    Success(:load_redirections_success, result: { redirections: Redirection.all })
  end

  def includes(redirections:, **)
    Success(:includes_success, result: {
      redirections: redirections.includes(:requisitions)
    })
  end

  def filter_by_id(redirections:, params:, **)
    return Success(:ilter_by_id_skipped) if params[:id].blank?

    Success(:filter_by_id_success, result: {
      redirections: redirections.where(id: params[:id])
    })
  end

  def filter_by_remote_ip(redirections:, params:, **)
    return Success(:ilter_by_remote_ip_skipped) if params[:remote_ip].blank?

    Success(:filter_by_remote_ip_success, result: {
      redirections: redirections.where(requisitions: { remote_ip: params[:remote_ip] })
    })
  end

  def filter_by_action_type(redirections:, params:, **)
    return Success(:ilter_by_action_type_skipped) if params[:action_type].blank?

    Success(:filter_by_action_type_success, result: {
      redirections: redirections.where(requisitions: { action_type: params[:action_type] })
    })
  end

  def search(redirections:, params:, **)
    return Success(:search_skipped) if params[:search].blank?

    search_term = "%#{params[:search]}%"

    redirections_table = Redirection.arel_table
    requisitions_table = Requisition.arel_table

    condition_target_url      = redirections_table[:target_url].matches(search_term, nil, true)
    condition_user_remote_ip  = requisitions_table[:remote_ip].matches(search_term, nil, false)
    condition_user_user_agent = requisitions_table[:user_agent].matches(search_term, nil, true)

    combined_condition = condition_target_url.or(condition_user_remote_ip).or(condition_user_user_agent)

    redirections = redirections.left_joins(:requisitions).where(combined_condition).distinct

    Success(:search_success, result: { redirections: redirections })
  end

  def order(redirections:, **)
    Success(:order_success, result: {
      redirections: redirections.order(id: :desc)
    })
  end

  def output(redirections:, **)
    Success(:get_success, result: { redirections: redirections })
  end
end
