class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :attachment_param

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if @attachment.attachmentable.user_id == current_user.id
  end

  private

  def attachment_param
    @attachment = Attachment.find(params[:id])
  end
end
