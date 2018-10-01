class MailingQueue
    include Mongoid::Document
    include Mongoid::Timestamps

    field :recipients, type: String
    field :status, type: Boolean
    field :action, type: String
    field :link, type: String

end
