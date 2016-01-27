FactoryGirl.define do
  factory :booking do 
      user_id 1
      checkin Time.now
      checkout Time.now + 1.hour
      active true
  end
end
