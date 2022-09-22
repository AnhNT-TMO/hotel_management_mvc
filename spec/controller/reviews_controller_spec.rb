require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe ReviewsController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:bill) { FactoryBot.create :bill, user: user }
  let(:room1) { FactoryBot.create :room }
  let(:room2) { FactoryBot.create :room }
  let(:book1) { FactoryBot.create :booking, user: user, bill: bill, room: room1, status: :checking }
  let(:book2) { FactoryBot.create :booking, user: user, bill: bill, room: room2, status: :confirm }

  before :each do
    sign_in user
  end

  describe "POST reviews#create" do
    context "when save review success" do
      it "should flash success" do
        book2
        post :create, params: {
          review: {room_id: room2.id, content: "abcde", rating: 5}
        }

        expect(flash[:success]).to eq I18n.t("reviews.create.review_success")
      end
    end


    context "when save review fail" do
      it "should flash danger" do
        book2
        allow_any_instance_of(Review).to receive(:save).and_return(false)
        post :create, params: {
          review: {room_id: room2.id, content: "abcde", rating: 5}
        }

        expect(flash[:danger]).to eq I18n.t("reviews.create.review_fail")
      end
    end

    context "when quantity review not valid" do
      it "should flash danger" do
        post :create, params: {
          review: {room_id: room1.id, content: "abcde", rating: 5}
        }

        expect(flash[:danger]).to eq I18n.t("reviews.create.quantity_review")
      end
    end

    context "when start invalid" do
      it "should flash danger" do
        book2
        post :create, params: {
          review: {room_id: room2.id, content: "abcde", rating: -1}
        }

        expect(flash[:danger]).to eq I18n.t("reviews.create.danger_star_review")
      end
    end
  end
end
