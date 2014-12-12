class SessionsController < ApplicationController
  def create
    flash.notice = "Successfully Logged In"
    redirect_to :root
  end
end
