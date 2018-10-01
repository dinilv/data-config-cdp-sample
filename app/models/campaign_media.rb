class CampaignMedia

    include Mongoid::Document

    field :media_id, type: Integer
    field :media_name, type: String
    field :media_cap,type:Integer
    field :media_link, type: String
    field :status, type: Integer, default: 1
    field :media_total_budget, type: Float
    field :media_daily_budget, type: Float
    field :media_total_cap, type: Integer
    field :media_daily_cap, type: Integer
    field :media_payout_dollar,type:Float
    field :media_payout_local,type:Float

    embedded_in :campaign, :inverse_of => :campaign_media

end
