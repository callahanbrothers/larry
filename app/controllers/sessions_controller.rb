class SessionsController < ApplicationController
  def create
    binding.pry
    flash.notice = "Successfully Logged In"
    redirect_to :root
  end
end
