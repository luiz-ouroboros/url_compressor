class CreateRedirections < ActiveRecord::Migration[8.0]
  def change
    create_table :redirections do |t|
      t.string :target_key, null: false, index: { unique: true }
      t.string :secret_key, null: false, index: { unique: true }
      t.string :target_url, null: false
      t.datetime :expire_at, null: true
      t.integer :requisition_count, default: 0

      t.timestamps

      t.index %i[target_key expire_at], name: 'index_redirections_on_target_key_and_expire_at'
      t.index %i[target_url expire_at], name: 'index_redirections_on_target_url_and_expire_at'
    end
  end
end
