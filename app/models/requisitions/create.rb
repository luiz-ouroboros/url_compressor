class Requisitions::Create < UseCase
  attributes :request, :redirection, :action_type

  def call!
    requisition = Requisition.create!(
      redirection: redirection,
      action_type: action_type,
      remote_ip: request.remote_ip,
      user_agent: request.user_agent.to_s
    )

    Success(:create_requisition_success, result: { requisition: requisition })
  end
end
