require "rails_helper"
require "spec_helper"
RSpec.describe BookingsController, type: :controller do
  let!(:user) { FactoryBot.create :user }
  let!(:bill) { FactoryBot.create :bill, user: user }
  let!(:room1) { FactoryBot.create :room }
  let!(:room2) { FactoryBot.create :room }
  let!(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let!(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    log_in user
  end

  describe "create new booking" do
    context "when date invalid" do
      before do
        post :create, params: {
          booking: {
            start_date: DateTime.now.to_date,
            end_date: DateTime.now.to_date,
            total_price: 1000,
            status: :pending,
            user_id: user.id,
            room_id: room1.id,
            bill_id: bill.id
          }
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.create.alert_date_invalid")
      end
    end

    context "when room cannot find" do
      before do
        post :create, params: {
          booking: {
            start_date: 5.days.from_now.to_date,
            end_date: 7.days.from_now.to_date,
            total_price: 1000,
            status: :pending,
            user_id: user.id,
            room_id: -1,
            bill_id: bill.id
          }
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.create.alert_room")
      end
    end

    context "when room was booked" do
      before do
        post :create, params: {
          booking: {
            start_date: DateTime.now.to_date,
            end_date: 2.days.from_now.to_date,
            total_price: 1000,
            status: :pending,
            user_id: user.id,
            room_id: room1.id,
            bill_id: bill.id
          }
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.create.room_was_booking")
      end

      it "Should redirect to rooms_path" do
        expect(response).to redirect_to rooms_path
      end
    end

    context "when bill cannot find" do
      before do
        allow_any_instance_of(Bill).to receive(:save).and_return(false)

        post :create, params: {
          booking: {
            start_date: 5.days.from_now.to_date,
            end_date: 7.days.from_now.to_date,
            total_price: 1000,
            status: :pending,
            user_id: user.id,
            room_id: room1.id,
            bill_id: bill.id
          }
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.create.danger_save_bill")
      end

      it "Should redirect to rooms_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when basket full" do
      before do
        allow_any_instance_of(Bill).to receive(:bookings).and_return([1,2,3,4])

        post :create, params: {
          booking: {
            start_date: 5.days.from_now.to_date,
            end_date: 7.days.from_now.to_date,
            total_price: 1000,
            status: :pending,
            user_id: user.id,
            room_id: room1.id,
            bill_id: bill.id
          }
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.create.basket_full")
      end

      it "Should redirect to rooms_path" do
        expect(response).to redirect_to rooms_path
      end
    end

    context "when create booking successfull" do
      before do
        post :create, params: {
          booking: {
            start_date: 5.days.from_now.to_date,
            end_date: 7.days.from_now.to_date,
            total_price: 1000,
            status: :pending,
            user_id: user.id,
            room_id: room1.id,
            bill_id: bill.id
          }
        }
      end

      it "Should display success flash" do
        expect(flash[:success]).to eq I18n.t("bookings.create.room_request_success")
      end

      it "Should redirect to rooms_path" do
        expect(response).to redirect_to rooms_path
      end
    end

    context "when invalid params" do
      before do
        post :create, params: {
          booking: {
            start_date: 5.days.from_now.to_date,
            end_date: 7.days.from_now.to_date,
            total_price: 1000,
            status: :pending,
            room_id: room1.id,
            bill_id: bill.id
          }
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.create.room_request_denied")
      end

      it "Should redirect to rooms_path" do
        expect(response).to redirect_to rooms_path
      end
    end

  end

  describe "destroy booking" do
    context "when destroy booking success" do
      it "Should display success flash" do
        allow_any_instance_of(Booking).to receive(:destroy).and_return(true)

        delete :destroy, params: {
          id: book1.id
        }
        expect(flash[:success]).to eq I18n.t("bookings.destroy.booking_delete_success")
      end
    end

    context "when destroy booking danger" do
      it "Should display danger flash" do
        allow_any_instance_of(Booking).to receive(:destroy).and_return(false)

        delete :destroy, params: {
          id: book1.id
        }

        expect(flash[:danger]).to eq I18n.t("bookings.destroy.booking_delete_denied")
      end
    end

    context "when admin check booking" do
      before do
        delete :destroy, params: {
          id: book2.id
        }
      end

      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.destroy.booking_was_checked")
      end
    end

    context "when cannot find booking" do
      before do
        delete :destroy, params: {
          id: -1
        }
      end
      it "Should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("bookings.destroy.alert_booking")
      end
    end
  end

  describe "GET bookings#index" do
    it "Should assign @bookings" do
      get :index
      expect(assigns(:bookings).pluck :id).to eq([book1.id, book2.id])
    end

    it "Should render index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
