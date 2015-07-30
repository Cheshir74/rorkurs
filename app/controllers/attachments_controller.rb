class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :attachment_param

  respond_to :js
  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def attachment_param
    @attachment = Attachment.find(params[:id])
  end
end
