class CreateRequisitions < ActiveRecord::Migration[8.0]
  def change
    create_table :requisitions do |t|
      t.references :redirection, null: true, foreign_key: true
      t.string :ip
      t.string :device
      t.string :os
      t.string :browser
      t.string :location
      t.string :action_type
      t.jsonb :metadata

      t.timestamps
    end
  end
end
