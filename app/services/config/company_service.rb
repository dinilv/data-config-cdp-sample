class Config::CompanyService < ApplicationService
  def create_company(company_data,ip)
    if (!Company.where(email: company_data[:email]).exists? && RegexValidation.email_validate(company_data[:email]) == 0)
      #Company.create_company(company_data)
      company = Company.new
      company.email = company_data[:email].downcase
      company.contact = company_data[:contact]
      company.country_id=company_data[:country_id]
      company.company_name=company_data[:company_name]
      company.currency_id=1
      company.timezone_id=1
      company.language_id=1
      company.keys = SecureRandom.hex(13)
      company.api_limit = 5000
      company.click_limit = 3000000
      member = Member.new
      member.email = company_data[:email]
      member.role = 4
      member.token = SecureRandom.hex(8)
      member.password_salt = SecureRandom.base64(6)
      member.password = Digest::SHA2.hexdigest(member.password_salt + "iiris")
      member.verified=true
      unless company.save && member.save
        return false, "Required fields are missing."
      else

        link = ACCOUNT_VERIFICATION + member.token
        mail_info = {"recipients" => member.email, "subject" => 'CMP Onboarding', "link" => link, "first_name" => company.first_name,"Password"=>"iiris"}
        Resque.enqueue(MailingJob,mail_info,1)
        return true, "Success"
      end
    elsif ContentProvider.where(email: company_data[:email]).exists?
      return false, "Email already used, please use different email address."
    elsif RegexValidation.email_validate(company_data[:email]) != 0
      return false, "Invalid email address."
    elsif company_data[:password] == company_data[:email]
      return false, "Password and email cannot be same."
    elsif company_data[:password] == company_data[:first_name]
      return false, "Password and first name cannot be same."
    end
  end
end