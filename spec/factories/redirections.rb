FactoryBot.define do
  factory :redirection do
    target_url { Faker::Internet.url }
    target_key { SecureRandom.alphanumeric(8) }
    secret_key { SecureRandom.hex(16) }
    expire_at { nil }
  end
end
