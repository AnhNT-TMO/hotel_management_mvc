require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe RoomsController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:bill) { FactoryBot.create :bill, user: user }
  let!(:room1) { FactoryBot.create :room }
  let!(:room2) { FactoryBot.create :room }
  let(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    sign_in user
  end

  describe "Show list rooms" do
    context "when user logged in" do
      it "Should assign @bookings" do
        get :index
        expect(assigns(:rooms).pluck :id).to eq([room1.id, room2.id])
      end
    end

    context "when user is guest" do
      it "Should assign @bookings" do
        sign_out user
        get :index
        expect(assigns(:rooms).pluck :id).to eq([room1.id, room2.id])
      end
    end

    context "when start_date >= end_date" do
      it "Should flash danger" do
        get :index, params: {
          search: {start_date_cont: DateTime.now.to_date, end_date_cont: DateTime.now.to_date}
        }

        expect(flash[:danger]).to eq I18n.t("rooms.index.date_danger")
      end
    end
  end

  describe "Show room" do
    it "Should show room" do
      get :show, params: {
        id: room1.id
      }

      expect(response).to render_template("show")
    end

    it "Should cannot find room" do
      get :show, params: {
        id: 9999
      }

      expect(flash[:danger]).to eq I18n.t("rooms.show.can_not_find_room")
    end
  end
end
