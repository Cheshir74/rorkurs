require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:otheruser) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, user: otheruser, question: question) }
  let(:attachment) { create(:attachment, attachmentable: question) }
  let(:attachment_an) { create(:attachment, attachmentable: answer) }

  describe 'DELETE #destroy' do

    sign_in_user

    it 'deletes specified attachment' do
      attachment
      expect { delete :destroy, id: attachment, format: :js }.to change(question.attachments, :count).by(-1)
    end

    it 'does not delete not authors question' do
      attachment_an
      expect { delete :destroy, id: attachment_an, format: :js }.to_not change(Attachment, :count)
    end

    it 'redirects to index page' do
      delete :destroy, id: attachment, format: :js
      expect(response).to render_template :destroy
    end
  end
end
