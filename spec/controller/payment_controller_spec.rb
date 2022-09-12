require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe PaymentController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:bill) { FactoryBot.create :bill, user: user, status: :pending }
  let(:room1) { FactoryBot.create :room }
  let(:room2) { FactoryBot.create :room }
  let(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :pending }
  let(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :checking }

  before :each do
    sign_in user
  end

  describe "POST payment#create" do
    it "should flash success" do
      book1
      post :create, params: {
        bill: {bill_id: bill.id}
      }

      expect(flash[:success]).to eq I18n.t("payment.create.success_payment")
    end

    context "when cannot find bill" do
      before do
        bill.status = :checking
        bill.save

        allow_any_instance_of(Bill).to receive(:save).and_return(false)

        post :create, params: {
          bill: {bill_id: bill.id}
        }
      end

      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("payment.create.danger_save_bill")
      end

      it "should redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when cannot find booking" do
      before do
        post :create, params: {
          bill: {bill_id: bill.id}
        }
      end

      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("payment.create.alert_booking")
      end

      it "should redirect to baskets_path" do
        expect(response).to redirect_to baskets_path
      end
    end

    context "when booking exists" do
      it "should flash erorr" do
        book2

        post :create, params: {
          bill: {bill_id: bill.id}
        }

        expect(flash[:error]).to eq I18n.t("payment.create.error_payment")
      end
    end

    context "when transaction error" do
      it "should redirect to baskets_path" do
        book1
        allow_any_instance_of(Bill).to receive(:save!).and_raise(StandardError)

        post :create, params: {
          bill: {bill_id: bill.id}
        }

        expect(response).to redirect_to baskets_path
      end
    end
  end
end
