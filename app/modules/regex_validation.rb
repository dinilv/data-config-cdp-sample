module RegexValidation
     def self.email_validate(email)
        # check if email regex is valid
        return email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
     end

     def self.name_validate(name)
        # check if name contains only alphabets
        return !name.match(/[^A-Za-z]/)
     end

end
