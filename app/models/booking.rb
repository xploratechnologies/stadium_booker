class Booking < ActiveRecord::Base


  validate :difference_is_greater_than_one_hour
  validate :checkin_is_lesser
  validate :is_valid_datetime
  validate :is_check_out_is_max_1_hour
  belongs_to :user

  scope :all_bookings, -> { order(checkin: "ASC")}

  def difference_is_greater_than_one_hour
    if (checkin + 1.hour) > checkout 
      errors.add("Dates", 'difference should be less than one hour') 
    end
  end

  def checkin_is_lesser  
    if checkin >= checkout
      errors.add(:checkin, 'should be less than Checkout date') 
    end
  end

  def is_check_out_is_max_1_hour
    if (checkin  < (checkout - 1.hour) )
      errors.add("Dates", 'difference should not be greater than one hour') 
    end
  end

  def conflicts(param)
    @conflict = false
    Booking.all.each do |booking|
      if !(Time.parse(booking.checkout.to_s)  <= param[:checkin].to_s ||
      Time.parse(booking.checkin.to_s) >= param[:checkout].to_s)
        @conflict = true
      end
    end
    errors.add('Stadium','Already booked in this interval') if @conflict == true
    return @conflict
  end

  def is_valid_datetime
    if ((DateTime.parse(checkin.to_s) rescue ArgumentError) == ArgumentError)
      errors.add(:checkin, 'must be a valid datetime')
    end
    if ((DateTime.parse(checkout.to_s) rescue ArgumentError) == ArgumentError)
      errors.add(:checkout, 'must be a valid datetime')
    end
  end
end
