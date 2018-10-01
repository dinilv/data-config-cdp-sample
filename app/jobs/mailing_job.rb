class MailingJob
  @queue = :mailing_queue
  def self.perform(mail_info,action)
      case action
      when 1
          UserMailer.signup(mail_info).deliver_now
          mailing_queue = MailingQueue.new
          mailing_queue.recipients = mail_info['recipients']
          mailing_queue.action = 'Signup'
          mailing_queue.link = mail_info['link']
          mailing_queue.save
      when 2
          UserMailer.forgotpassword(mail_info).deliver_now
          mailing_queue = MailingQueue.new
          mailing_queue.recipients = mail_info['recipients']
          mailing_queue.action = 'Forgot Password'
          mailing_queue.link = mail_info['link']
          mailing_queue.save
      end
  end
end
