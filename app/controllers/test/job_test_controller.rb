class Test::JobTestController < ApplicationController

  def testaccount

    Assigner::AccountJob.perform

    render :json => {status: false, status_code:200, message: 'success', data: []}, :status => 200
  end

  def testlifetime

    Assigner::LifetimeJob.perform
    Assigner::MsisdnJob.perform

    render :json => {status: false, status_code:200, message: 'success', data: []}, :status => 200
  end

  def zero_data_job

    start_date = Date.parse('2018-04-20')
    end_date = Date.parse('2018-06-30')

    (start_date..end_date).each do |day|
      now_formatted=DateUtility.getUtcStartDateFromDate(day)
      Imports::ZeroDataJob.create_zero_data(now_formatted)
    end
    render :json => {status: false, status_code:200, message: 'success', data: []}, :status => 200
  end

  def add_default_data

    Imports::MsisdnJob.perform

    start_date = Date.parse('20/04/2018')
    end_date = Date.parse('11/06/2018')
    if params[:sdate]
      start_date=Date.parse(params[:sdate])
    end
    if params[:edate]
      end_date=Date.parse(params[:edate])
    end

    (start_date..end_date).each do |day|
      puts day
      Imports::CmpJob.custom(day.strftime("%d/%m/%Y"),day.strftime("%d/%m/%Y"))
      Assigner::CampaignJob.perform
    end
    render :json => {status: false, status_code:200, message: 'success', data: []}, :status => 200
  end

  def delete_job
    Campaign::MediaDaily.where({}).delete
    Campaign::SummaryDaily.where({}).delete
    Campaign::OperatorDaily.where({}).delete
    Campaign::SummaryThirty.where({}).delete
    Campaign::SummaryLifetime.where({}).delete
    Campaign::MediaLifetime.where({}).delete
    Campaign::OperatorLifetime.where({}).delete
    Campaign::MediaOperatorDaily.where({}).delete

    Account::MediaDaily.where({}).delete
    Account::MediaLifetime.where({}).delete
    Account::MediaOperatorDaily.where({}).delete
    Account::OperatorLifetime.where({}).delete
    Account::OperatorDaily.where({}).delete
    Account::SummaryDaily.where({}).delete
    Account::SummaryLifetime.where({}).delete

    Msisdn::Daily.where({}).delete
    Msisdn::Lifetime.where({}).delete

    Report::StandardMediaDaily.where({}).delete
    Report::StandardMsisdnDaily.where({}).delete
    Report::StandardOperatorDaily.where({}).delete

    render :json => {status: false, status_code:200, message: 'success', data: []}, :status => 200
  end

end
