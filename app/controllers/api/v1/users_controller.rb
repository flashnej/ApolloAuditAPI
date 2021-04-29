require 'csv'
require 'sendgrid-ruby'
include SendGrid
require 'pry'

class Api::V1::UsersController < ApplicationController
    protect_from_forgery with: :null_session

  def index
    user = params["id"]
    projects = Project.where(auditor: user)

    render json: {projects: projects}
  end

  def show
    user = params["id"]
    projects = Project.where(auditor: user)

    render json: {projects: projects}

  end
end
