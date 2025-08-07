class ContactFormController < ApplicationController
    def new
   
    end

    def index
        redirect_to new_contact_form_path
    end
    def create
        @name=params[:contact_form][:name]
        @email=params[:contact_form][:email]
        @message=params[:contact_form][:message]

        NotifierMailer.simple_message(@name, @email, @message).deliver_now

        flash[:success] = "Wiadomość została wysłana."
        redirect_to posts_path
    end

end
