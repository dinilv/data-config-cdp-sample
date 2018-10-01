class CampaignOperator
    include Mongoid::Document
    include Mongoid::Timestamps

    field :operator_id, type: Integer
    field :status, type: Integer, default: 1
    embedded_in :campaign, :inverse_of => :campaign_operator

end
