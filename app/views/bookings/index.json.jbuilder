json.array!(@bookings) do |booking|
  json.extract! booking, :id, :user_id, :checkin, :checkout, :active
  json.url booking_url(booking, format: :json)
end
