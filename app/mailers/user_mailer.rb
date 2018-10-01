class UserMailer < ApplicationMailer
default from: 'camiemail@adcamie.com'

  def send_emails(mail_info,to,cc)
  	@mail_information = mail_info
    mail(to: to, cc: cc, subject: @mail_information['subject'],template_path: 'user_mailer',
         template_name: 'send_emails')

  end

  def signup(mail_info)
    begin
    puts "in signup"
  	@mail_information = mail_info
    puts @mail_information['recipients']
    value = mail(to: @mail_information['recipients'], subject: @mail_information['subject'],template_path: 'user_mailer',
         template_name: 'signup')
    rescue Exception => e
      puts "Exception occured: " + e
    end
  end

  def forgotpassword(mail_info)
  	@mail_information = mail_info
    mail(to: @mail_information['recipients'], subject: @mail_information['subject'],template_path: 'user_mailer',
         template_name: 'forgotpassword')
  end

end
