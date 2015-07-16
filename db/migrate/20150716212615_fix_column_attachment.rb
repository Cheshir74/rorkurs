class FixColumnAttachment < ActiveRecord::Migration
  def change
    remove_index :attachments, :attachmentable_type
    remove_index :attachments, :attachmentable_id
    add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
