require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe Admin::BookingsController, type: :controller do
  let(:user) { FactoryBot.create :user, role: :admin}
  let(:bill) { FactoryBot.create :bill, user: user }
  let(:room1) { FactoryBot.create :room }
  let(:room2) { FactoryBot.create :room }
  let!(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let!(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    sign_in user
  end

  describe "GET bookings#index" do
    it "should assign @bookings" do
      get :index, params: {
        bill_id: bill.id
      }

      expect(assigns(:bookings).pluck :id).to eq([book1.id, book2.id])
    end
  end

  describe "PATCH bookings#update" do
    context "when update success" do
      it "should flash success" do
        patch :update, params: {
          bill_id: bill.id,
          id: book1.id,
          booking: {
            reason: "asdasdasdsa",
            status: :abort
          }
        }

        expect(flash[:success]).to eq I18n.t("admin.bookings.update.update_success")
      end
    end

    context "when update fail" do
      it "should flash danger" do
        allow_any_instance_of(Booking).to receive(:update).and_return(false)

        patch :update, params: {
          bill_id: bill.id,
          id: book1.id,
          booking: {
            reason: "asdasdasdsa",
            status: :abort
          }
        }

        expect(flash[:danger]).to eq I18n.t("admin.bookings.update.update_fail")
      end
    end
  end

  describe "GET admin_bookings#edit" do
    context "when cannot find booking" do
      it "should flash danger" do
        allow(Booking).to receive(:find_by).and_return(nil)

        get :edit, params: {
          bill_id: bill.id,
          id: book1.id
        }

        expect(flash[:danger]).to eq I18n.t("admin.bookings.edit.load_booking_failed")
      end
    end
  end
end
