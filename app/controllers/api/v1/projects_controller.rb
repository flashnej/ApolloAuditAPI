require 'csv'
require 'sendgrid-ruby'
include SendGrid
require 'pry'

class Api::V1::ProjectsController < ApplicationController
    protect_from_forgery with: :null_session

  def create
    date = Time.new.strftime("%m/%d/%Y")
    params["projectName"] ? (project_name = params["projectName"]) : (project_name = "")
    params["clientName"] ? (client_name = params["clientName"]) : (client_name = "")
    params["contactName"] ? (contact_name = params["contactName"]) : (contact_name = "")
    params["phoneNumber"] ? (phone_number = params["phoneNumber"]) : (phone_number = "")
    params["address"] ? (address = params["address"]) : (address = "")
    params["clientName"] ? (city = params["clientName"]) : (city = "")
    params["sqFt"] ? (sq_ft = params["sqFt"]) : (sq_ft = "")
    params["utility"] ? (utility = params["utility"]) : (utility = "")
    params["acctNum"] ? (acct_num = params["acctNum"]) : (acct_num = "")
    params["lineItems"] ? (line_items = params["lineItems"]) : (line_items = "")
    params["useremail"] ? (auditor_email = params["useremail"]) : (auditor_email = "")
    params["user"] ? (auditor = params["user"]) : (auditor = "")

    project = Project.new
    project.name = project_name
    project.auditor = auditor
    project.contact_name = contact_name
    project.phone_number = phone_number
    project.address = address
    project.city = city
    project.sq_ft = sq_ft
    project.utility = utility
    if project.save
      csv = CSV.generate do |csv|
        csv << ["","","","","","","","","","","","","","Date: " + date]
        csv << ["","Project Name: "+project_name,"","","","Contact Name: "+contact_name,"","","","","","","","Phone #" +phone_number]
        csv << ["","Address: "+ address,"","","","City/Town: "+ city,"","","","","","","","Sq. Ft.: "+sq_ft]
        csv << ["", "Location", "Hrs/ Yr", "Existing Fixture", "Existing QTY", "Proposed Option", "Proposed QTY", "Voltage", "Notes"]
        line_number = 1
        line_items.map do |line|
          csv << [line_number,line[0],line[1],line[2],line[3],line[4],line[5],line[6],line[7]]
          line_number += 1
          line_item = LineItem.new
          line_item.project = project
          line_item.location = line[0]
          line_item.hrs_per_year = line[1]
          line_item.existing_fixture = line[2]
          line_item.existin_qty = line[3]
          line_item.proposed_fixture = line[4]
          line_item.proposed_qty = line[5]
          line_item.volt = line[6]
          line_item.notes = line[7]
          line_item.save
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
  end


  def index
  render json: {hi: "hi"}
  end

  def show
    user = params["id"]
    projects = Project.where(auditor: user)

    render json: {projects: projects}

  end
end
