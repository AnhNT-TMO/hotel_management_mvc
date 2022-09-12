require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe HistoriesController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  let!(:bill) { FactoryBot.create :bill, user: user }
  let(:room1) { FactoryBot.create :room }
  let(:room2) { FactoryBot.create :room }
  let!(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let!(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    sign_in user
  end

  describe "Get histories#show" do
    it "should assign @bills" do
      get :show

      expect(assigns(:bills).pluck :id).to eq([bill.id])
    end

    context "when user does not have any bill" do
      it "should flash danger" do
        sign_in user2

        get :show

        expect(flash[:danger]).to eq I18n.t("histories.show.bill_not_exists")
      end
    end
  end
end
