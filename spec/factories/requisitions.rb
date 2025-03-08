FactoryBot.define do
  factory :requisition do
    redirection
    remote_ip { Faker::Internet.ip_v4_address }
    action_type { 'show' }
    user_agent { Faker::Internet.user_agent }
  end
end
