class CatRentalRequestsController < ApplicationController

  def approve
    if current_cat.owner == current_user
      current_cat_rental_request.approve!
      redirect_to cat_url(current_cat)
    else
      redirect_to cat_url(current_cat)
    end
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    if current_cat.owner == current_user
      current_cat_rental_request.deny!
      redirect_to cat_url(current_cat)
    else
      redirect_to cat_url(current_cat)
    end
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
