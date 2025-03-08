class Redirection < ApplicationRecord
  has_many :requisitions

  APP_HOST = ENV['APP_HOST'].freeze
  TARGET_KEY_LENGTH = ENV['TARGET_KEY_LENGTH']&.to_i || 10

  def short_url
    "#{APP_HOST}/#{target_key}"
  end

  def generate_target_key
    10.times do
      candidate_key = SecureRandom.alphanumeric(TARGET_KEY_LENGTH)
      unless Redirection.exists?(target_key: candidate_key)
        self.target_key = candidate_key
        return
      end
    end

    raise(StandardError, 'Could not generate unique target_key after 10 attempts')
  end

  def generate_secret_key
    10.times do
      candidate = SecureRandom.alphanumeric(16)
      unless Redirection.exists?(secret_key: candidate)
        self.secret_key = candidate
        return
      end
    end

    raise(StandardError, 'Could not generate unique secret_key after 10 attempts')
  end
end
