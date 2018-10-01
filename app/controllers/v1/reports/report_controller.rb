class V1::Reports::ReportController < ApplicationController
  require 'csv'
  def upload_csv
    csv_data = CSV.parse(request.body)
    headers = csv_data[0]
    unless headers.include?('clicks') && headers.include?('conversions') && headers.include?('impressions') && headers.include?('engagement')
      debugger
    end
    csv_data.each_with_index do |row_data,index|
      next if index == 0
      report = Report.new
      row_json = {}
      headers.each_with_index do |coloumn_data,coloumn_index|
        row_json[coloumn_data] = row_data[coloumn_index]
      end
      campaign_details = Campaign.where(campaign_id: row_json['campaign_id'].to_i)[0]
      media_details = Media.where(media_id: row_json['media_id'].to_i)[0]
      report.campaign_id = row_json['campaign_id'].to_i
      report.campaign_name = campaign_details.campaign_name
      report.media_id = row_json['media_id'].to_i
      report.media_name = media_details.media_name
      unless CampaignMedia.where(campaign_id: row_json['campaign_id'].to_i, media_id: row_json['media_id']).exists?
        next
      end
      campaign_media_details = CampaignMedia.where(campaign_id: row_json['campaign_id'].to_i, media_id: row_json['media_id'])[0]
      report.clicks = row_json['clicks'].to_i
      report.conversions = row_json['conversions'].to_i
      report.impressions = row_json['impressions'].to_i
      report.media_cost = campaign_media_details.media_payout * report.conversions
      report.revenue = campaign_details.unit_charge * report.conversions
      report.date = Date.parse(row_json['date'])
      report.day_of_year = report.date.yday()
      report.week_of_year = report.date.strftime("%W").to_i
      report.month = report.date.strftime("%m").to_i
      report.year = report.date.strftime("%Y").to_i
      report.three_day_unsubcription = row_json['three_day_unsubcription']
      report.seven_day_unsubscription = row_json['seven_day_unsubscription']
      report.fifteen_day_unsubscription = row_json['fifteen_day_unsubscription']
      report.unsubscriptions = row_json['unsubscriptions']
      report.subscribers = row_json['subscribers']
      report.active_subscribers = row_json['active_subscribers']
      report.mt_sent = row_json['mt_sent']
      report.mt_success = row_json['mt_success']
      report.content_view = row_json['content_view']
      # delete existing report for the campaign on the date before inserting the new report
      Report.where(campaign_id: row_json['campaign_id'],media_id: row_json['media_id'],date: Date.parse(row_json['date'])).destroy
      report.save!
      debugger
    end
    debugger
  end
end
