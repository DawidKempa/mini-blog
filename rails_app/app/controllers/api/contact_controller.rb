# app/controllers/api/contact_controller.rb
class Api::ContactController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    name = params[:name]
    email = params[:email]
    message = params[:message]

    if name.blank? || email.blank? || message.blank?
      render json: { error: "Wszystkie pola są wymagane." }, status: :unprocessable_entity
      return
    end

    NotifierMailer.simple_message(name, email, message).deliver_now
    render json: { message: "Wiadomość została wysłana." }, status: :ok
  end
end
