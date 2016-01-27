class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.datetime :checkin
      t.datetime :checkout
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
