require 'rails_helper'

RSpec.describe Redirection, type: :model do
  describe '#generate_target_key' do
    let(:redirection) { Redirection.new }

    it 'generates a target_key with correct length' do
      redirection.generate_target_key
      expect(redirection.target_key.length).to eq(Redirection::TARGET_KEY_LENGTH)
    end

    it 'generates unique target_keys' do
      keys = []
      5.times do
        redirection = Redirection.new
        redirection.generate_target_key
        keys << redirection.target_key
      end
      expect(keys.uniq.length).to eq(keys.length)
    end

    it 'raises error after 10 failed attempts' do
      allow(Redirection).to receive(:exists?).with(hash_including(target_key: anything)).and_return(true)

      expect { redirection.generate_target_key }.to raise_error(
        StandardError, 'Could not generate unique target_key after 10 attempts'
      )
    end
  end

  describe '#generate_secret_key' do
    let(:redirection) { Redirection.new }

    it 'generates a secret_key with length of 16' do
      redirection.generate_secret_key
      expect(redirection.secret_key.length).to eq(16)
    end

    it 'generates unique secret_keys' do
      keys = []
      5.times do
        redirection = Redirection.new
        redirection.generate_secret_key
        keys << redirection.secret_key
      end
      expect(keys.uniq.length).to eq(keys.length)
    end

    it 'raises error after 10 failed attempts' do
      allow(Redirection).to receive(:exists?).with(hash_including(secret_key: anything)).and_return(true)

      expect { redirection.generate_secret_key }.to raise_error(
        StandardError, 'Could not generate unique secret_key after 10 attempts'
      )
    end
  end
end
