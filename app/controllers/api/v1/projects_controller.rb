require 'csv'
require 'sendgrid-ruby'
include SendGrid

class Api::V1::ProjectsController < ApplicationController
    protect_from_forgery with: :null_session

  def create
    date = Time.new.strftime("%m/%d/%Y")
    project_name = params["projectName"]
    client_name = params["clientName"]
    contact_name = params["contactName"]
    phone_number = params["phoneNumber"]
    address = params["address"]
    city = params["city"]
    sq_ft = params["sqFt"]
    utility = params["utility"]
    acct_num = params["acctNum"]
    line_items = params["lineItems"]
    auditor_email=params["useremail"]

    csv = CSV.generate do |csv|
      csv << ["","","","","","","","","","","","","","Date: " + date]
      csv << ["","Project Name: "+project_name,"","","","Contact Name: "+contact_name,"","","","","","","","Phone #" +phone_number]
      csv << ["","Address: "+ address,"","","","City/Town: "+ city,"","","","","","","","Sq. Ft.: "+sq_ft]
      csv << ["", "Location", "Hrs/ Yr", "Existing Fixture", "Existing QTY", "Proposed Option", "Proposed QTY", "Voltage", "Notes"]
      line_number = 1
      line_items.map do |line|
        csv << [line_number,line[0],line[1],line[2],line[3],line[4],line[5],line[6],line[7]]
        line_number += 1
      end
    end

    data = {
      'personalizations': [
        {
          'to': [
            {
              'email': auditor_email
            }
          ],
          'subject': project_name +' Audit'
        }
      ],
      'from': {
        'email': 'apolloauditapp@gmail.com'
      },
      'content': [
        {
          'type': 'text/plain',
          'value': 'Your audit is attached'
        }
      ]
    }
    data[:attachments] = [
      {
        content: Base64.strict_encode64(csv),
        filename: "Audit.csv",
        type: 'csv'
      }
    ]
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._("send").post(request_body: data)
    puts response.status_code
    puts response.body
    puts response.headers
  end


  def index
  render json: {hi: "hi"}
  end
end
