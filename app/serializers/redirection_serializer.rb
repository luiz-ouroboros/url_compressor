class RedirectionSerializer < ActiveModel::Serializer
  attributes :id,
             :target_key,
             :secret_key,
             :target_url,
             :short_url,
             :expire_at,
             :requisition_count,
             :created_at,
             :updated_at
end
