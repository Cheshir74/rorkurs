class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :attachment_param

  def destroy
    if @attachment.attachmentable.user_id == current_user.id
     @attachment.destroy
    end
  end

  private

  def attachment_param
    @attachment = Attachment.find(params[:id])
  end
end
