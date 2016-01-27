module BookingsHelper
  def booked_by(user_id)
  	User.find_by(id: user_id).email
  end
end
