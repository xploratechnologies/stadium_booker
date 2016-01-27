require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    @booking = FactoryGirl.build(:booking)
  end

  describe "Booking dashboard" do
    it "should load page  after sign in" do
      sign_in @user
      get :index
      expect(response).to have_http_status(:success)
    end
    it "should load page  before sign in" do
      get :index
      expect(response).to have_http_status(302)
    end
  end

  describe "Booking stadium" do
    it "should able to book if checkin and check out is valid" do
      expect(@booking.save).to eq(true)
    end

    it "should not be able to book if checkin is greater than checkout" do
      @booking = FactoryGirl.build(:booking, checkin: Time.now + 4.hour)
      expect(@booking.save).to eq(false)
    end

    it "should not be able to book if checkout is lesser than checkin" do
      @booking = FactoryGirl.build(:booking, checkout: Time.now - 4.hour)
      expect(@booking.save).to eq(false)
    end

    it "should not be able to book if checkin and check out difference is 10 minute" do
      @booking = FactoryGirl.build(:booking, checkout: Time.now + 10.minute)
      expect(@booking.save).to eq(false)		
    end

    it "should able to book if checkin and check difference is greater than one" do
      @booking = FactoryGirl.build(:booking, checkout: Time.now)
      expect(@booking.save).to eq(false)
    end
  end

  describe "Booking edit" do
    it "should be able to edit" do
      sign_in @user
      @booking = FactoryGirl.create(:booking)
      get :edit, id: @booking.id
      expect(response).to have_http_status(200)
    end
  end

  describe "Booking #create" do
    it "should be able to create booking" do
      sign_in @user
      @booking = FactoryGirl.attributes_for(:booking)
      expect{ post :create, booking: @booking}.to change(Booking,:count).by(1)
    end

    it "should not allow to create booking without login" do
      @booking = FactoryGirl.attributes_for(:booking)
      expect{ post :create, booking: @booking}.to change(Booking,:count).by(0)
    end

    it "should be redirect to booking #index page" do
      sign_in @user
      @booking = FactoryGirl.attributes_for(:booking)
      expect{ post :create, booking: @booking }.to change(Booking,:count).by(1)
      response.should redirect_to bookings_path
    end
  end

  describe "Booking update" do
    it "located the requested @booking" do
      sign_in @user
      @booking = FactoryGirl.create(:booking)
      put :update, id: @booking, booking: FactoryGirl.attributes_for(:booking)
      assigns(:booking).should eq(@booking)      
    end

    it "redirects to the updated contact" do
      sign_in @user
      @booking = FactoryGirl.create(:booking)
      put :update, id: @booking, booking: FactoryGirl.attributes_for(:booking)
      expect(response).to have_http_status(200)
    end
  end
  describe 'DELETE destroy' do
    before :each do
      sign_in @user
      @booking = FactoryGirl.create(:booking)
    end

    it "deletes the contact" do
      expect{
        delete :destroy, id: @booking       
      }.to change(Booking,:count).by(-1)
    end

    it "redirects to contacts#index" do
      delete :destroy, id: @booking
      response.should redirect_to bookings_url
    end
  end
end
