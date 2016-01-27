class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index
    @bookings = Booking.all_bookings
  end

  def new
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = Booking.new(booking_params)
    @booking_conflict = @booking.conflicts(booking_params)
    respond_to do |format|
      unless @booking_conflict
        if @booking.save
          format.html { redirect_to bookings_path, notice: 'Booking was successfully done.' }
          format.json { render :json, status: :created, location: @booking }
        else
          format.html { render :new }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @booking_conflict = @booking.conflicts(booking_params)
    respond_to do |format|
      unless @booking_conflict
        if @booking.update(booking_params)
          format.html { redirect_to bookings_path, notice: 'Booking was successfully updated.' }
          format.json { render :json, status: :ok, location: @booking }
        else
          format.html { render :edit }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end
    
    def booking_params
      params.require(:booking).permit(:user_id, :checkin, :checkout, :active)
    end
end
