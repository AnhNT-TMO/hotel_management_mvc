require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe Admin::BillsController, type: :controller do
  let(:user) { FactoryBot.create :user, role: :admin}
  let(:bill) { FactoryBot.create :bill, user: user }
  let(:room1) { FactoryBot.create :room }
  let(:room2) { FactoryBot.create :room }
  let!(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let!(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    sign_in user
  end

  describe "GET admin_bills#index" do
    it "should assign @bills" do
      get :index

      expect(assigns(:bills).pluck :id).to eq([bill.id])
    end
  end

  describe "PATCH admin_bills#update" do
    context "when update success" do
      it "should flash success" do
        patch :update, params: {
          id: bill.id,
          bill: {
            status: :confirm
          }
        }

        expect(flash[:success]).to eq I18n.t("admin.bills.update.update_success")
      end
    end

    context "when update fail" do
      it "should flash danger" do
        allow_any_instance_of(Bill).to receive(:update).and_raise(StandardError)

        patch :update, params: {
          id: bill.id,
          bill: {
            status: :confirm
          }
        }

        expect(response).to redirect_to admin_bills_path
      end
    end
  end

  describe "GET admin_bills#edit" do
    context "when cannot find bill" do
      it "should flash danger" do
        allow(Bill).to receive(:find_by).and_return(nil)

        get :edit, params: {
          id: bill.id
        }

        expect(flash[:danger]).to eq I18n.t("admin.bills.edit.load_room_failed")
      end
    end
  end
end
