class CreateRequisitions < ActiveRecord::Migration[8.0]
  def change
    create_table :requisitions do |t|
      t.references :redirection, null: true, index: { unique: false }
      t.string :action_type
      t.string :remote_ip
      t.string :user_agent
      t.jsonb :metadata

      t.timestamps
    end
  end
end
