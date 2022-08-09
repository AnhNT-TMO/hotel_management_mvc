require "rails_helper"
require "spec_helper"

RSpec.describe Booking, type: :model do
  let!(:user) { FactoryBot.create :user }
  let!(:bill1) { FactoryBot.create :bill, user: user }
  let!(:bill2) { FactoryBot.create :bill, user: user }
  let!(:room1) { FactoryBot.create :room, price: 1000 }
  let!(:room2) { FactoryBot.create :room }
  let!(:book1) { FactoryBot.create :booking, start_date: Settings.day.two_day_from_now.days.from_now.to_date,
    end_date: Settings.day.four_day_from_now.days.from_now.to_date, user: user, bill: bill1, room: room1 }
  let!(:book2) { FactoryBot.create :booking, user: user, bill: bill2, room: room2, status: :confirm }
  let!(:book3) { FactoryBot.create :booking, user: user, bill: bill2, room: room2, status: :checking }

  describe "associations" do
    context "with belong to" do
      it {is_expected.to belong_to(:user)}
      it {is_expected.to belong_to(:room)}
      it {is_expected.to belong_to(:bill)}
    end
  end

  describe "validations" do
    context "presence" do
      it {is_expected.to validate_presence_of(:start_date)}
      it {is_expected.to validate_presence_of(:end_date)}
      it {is_expected.to validate_presence_of(:total_price)}
    end
  end

  describe "Check scope" do
    describe ".by_bills" do
      it "Should return booking if bill_id that match" do
        expect(Booking.by_bills(bill1.id).pluck :id).to eq([book1.id])
      end

      it "Should return exception if not fill params" do
        expect(Booking.by_bills("").pluck :id).to eq([book1.id, book2.id, book3.id])
      end
    end

    describe ".recent_bookings" do
      it "Should order by created_date of booking" do
        expect(Booking.recent_bookings.pluck :id).to eq([book1.id, book2.id, book3.id])
      end
    end

    describe ".booking_order" do
      it "Should order by id of booking" do
        expect(Booking.booking_order.pluck :id).to eq([book1.id, book2.id, book3.id])
      end
    end

    describe ".find_booking" do
      it "Should return booking if user_id that match" do
        expect(Booking.find_booking(user.id).pluck :id).to eq([book1.id, book2.id, book3.id])
      end
    end

    describe ".check_exist_booking" do
      it "Should return booking if start_date and end_date match" do
        expect(Booking.check_exist_booking(book1.start_date, book1.end_date).pluck :id).to eq([book1.id])
      end
    end

    describe ".find_room_with_id" do
      it "Should return booking if room_id that match" do
        expect(Booking.find_room_with_id(book1.room_id).pluck :id).to eq([book1.id])
      end
    end

    describe ".find_booking_was_not_pending" do
      it "Should return booking if status that match" do
        expect(Booking.find_booking_was_not_pending.pluck :id).to eq([book2.id, book3.id])
      end
    end

    describe ".check_user_booking_confirm" do
      it "Should return booking if room_id that match" do
        expect(Booking.check_user_booking_confirm(user.id, room1.id).pluck :id).to eq([book1.id])
      end
    end
  end

  describe "#calculate_total_price" do
    it "Should return total_price calculated" do
      expect(book1.calculate_total_price(room1)).to eq(2000)
    end
  end

  describe ".booking_ids" do
    it "Should return list room_id that match" do
      expect(Booking.booking_ids(book1.start_date, book1.end_date, user.id)).to eq([book1.room_id])
    end
  end

  describe "#calculate_total_price" do
    it "Should return total_price calculated" do
      expect(book3.check_status_destroy).to eq(true)
    end

    it "Should return bill destroy" do
      allow_any_instance_of(Bill).to receive(:total_price).and_return(0)

      expect(book3.check_status_destroy).to eq(bill2)
    end
  end
end
