class SessionsController < ApplicationController

  def new
  end

  def create
    # note: form_tag took out :sessions here which seemed to make it simpler - Exercise 8.5
  	user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
