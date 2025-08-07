class NotifierMailer < ApplicationMailer
    default to: "dawidkempa1studia@gmail.com",
    from: "contact@mailtrap.club"

    def simple_message(name, email, message)
        mail(
            "reply_to" => email_address_with_name(email, "#{name}"),
            subject: "New contact form message from #{name}",
            body: message
        )
    end
end
