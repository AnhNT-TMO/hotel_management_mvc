require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe BasketsController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let!(:bill) { FactoryBot.create :bill, user: user, status: :pending }
  let(:room1) { FactoryBot.create :room }
  let(:room2) { FactoryBot.create :room }
  let!(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :pending }
  let(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :checking }

  before :each do
    sign_in user
  end

  describe "Get baskets#show" do
    it "should return a list booking item" do
      get :show
      expect(assigns(:bookings).pluck :id).to eq([book1.id])
    end

    context "when cannot find bill" do
      before do
        bill.status = :checking
        bill.save

        allow_any_instance_of(Bill).to receive(:save).and_return(false)

        get :show
      end

      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("baskets.show.danger_save_bill")
      end

      it "should redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "Delete baskets#destroy" do
    it "should delete success" do
      delete :destroy, params: {
        checkbox_1: {result: 1},
        booking_id_1: book1.id
      }

      expect(flash[:success]).to eq I18n.t("baskets.destroy.booking_delete_success")
    end

    context "when do not booking selected" do
      before do
        delete :destroy, params: {
          checkbox_1: {result: 0},
          booking_id_1: book1.id
        }
      end

      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("baskets.destroy.blank_selected")
      end

      it "should redirect to root_path" do
        expect(response).to redirect_to baskets_path
      end
    end

    context "when cannot delete booking" do
      before do
        delete :destroy, params: {
          checkbox_1: {result: 1},
          booking_id_1: book2.id
        }
      end

      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("baskets.destroy.room_request_denied")
      end

      it "should redirect to root_path" do
        expect(response).to redirect_to baskets_path
      end
    end
  end
end
