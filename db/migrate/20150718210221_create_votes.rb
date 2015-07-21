class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user
      t.references :votable, polymorphic: true, index: true
      t.index [:votable_id, :votable_type, :user_id], unique: true

      t.timestamps null: false
    end
  end
end