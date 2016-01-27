class Booking < ActiveRecord::Base


  validate :difference_is_greater_than_one_hour
  validate :checkin_is_lesser
  validate :is_valid_datetime

  belongs_to :user

  scope :all_bookings, -> { order(checkin: "ASC")}

  def difference_is_greater_than_one_hour
    if (checkin + 1.hour) > checkout 
      errors.add("Dates", 'difference should be less than one hour') 
    end
  end

  def checkin_is_lesser
    if checkin > checkout
      errors.add(:checkin, 'should be less than Checkout date') 
    end
  end

  def conflicts(param)
    Booking.all.each do |booking|
      if !(Time.parse(booking.checkout.to_s)  <= Time.parse(param[:checkin].to_s) ||
      Time.parse(booking.checkin.to_s) >= Time.parse(param[:checkout].to_s))
        self.errors.add('Stadium','Already booked in this interval')
        return booking
      else
        nil
      end
    end
  end

  def is_valid_datetime
    if ((DateTime.parse(checkin.to_s) rescue ArgumentError) == ArgumentError)
      errors.add(:checkin, 'Checkin must be a valid datetime')
    end
    if ((DateTime.parse(checkout.to_s) rescue ArgumentError) == ArgumentError)
      errors.add(:checkout, 'Checkout must be a valid datetime')
    end
  end
end
