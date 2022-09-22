require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe Admin::RoomsController, type: :controller do
  let(:user) { FactoryBot.create :user, role: :admin}
  let(:bill) { FactoryBot.create :bill, user: user }
  let!(:room1) { FactoryBot.create :room }
  let!(:room2) { FactoryBot.create :room }
  let(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    sign_in user
  end

  describe "GET admin_rooms#index" do
    it "should assign @rooms" do
      get :index

      expect(assigns(:rooms).pluck :id).to eq([room2.id, room1.id])
    end
  end

  describe "POST admin_rooms#create" do
    context "when create successfully" do
      it "should save and flash success" do
        post :create, params: {
          room: {
            name: "asdsadsa",
            description: "sdsadsadas",
            price: 120000,
            types: :Single
          }
        }

        expect(flash[:success]).to eq I18n.t("admin.rooms.create.alert")
      end

      it "should flash danger" do
        allow_any_instance_of(Room).to receive(:save).and_return(false)
        post :create, params: {
          room: {
            name: "asdsadsa",
            description: "sdsadsadas",
            price: 120000,
            types: :Single
          }
        }

        expect(flash[:danger]).to eq I18n.t("admin.rooms.create.alert_not_save")
      end
    end
  end

  describe "PUT admin_rooms#update" do
    context "when update success" do
      it "flash success" do
        patch :update, params: {
          id: room1.id,
          room: {name: "asdsadas"}
        }

        expect(flash[:success]).to eq I18n.t("admin.rooms.update.update_success")
      end
    end

    context "when update denied" do
      it "flash success" do
        allow_any_instance_of(Room).to receive(:update).and_return(false)

        patch :update, params: {
          id: room1.id,
          room: {name: "asdsadas"}
        }

        expect(flash[:danger]).to eq I18n.t("admin.rooms.update.update_fail")
      end
    end
  end

  describe "GET admin_rooms#edit" do
    context "when cannot find room" do
      it "should flash danger" do
        allow(Room).to receive(:find_by).and_return(nil)

        get :edit, params: {
          id: room1.id
        }

        expect(flash[:danger]).to eq I18n.t("admin.rooms.edit.load_room_failed")
      end
    end
  end

  describe "GET admin_rooms#new" do
    it "should render new template" do
      get :new

      expect(response).to render_template("new")
    end
  end
end
