class SubscribeNewAnswer < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.references :question, index: true
      t.references :user, index: true

    end
  end
end
