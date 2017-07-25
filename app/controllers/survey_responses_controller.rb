require 'twilio-ruby'

class SurveyResponsesController < ApplicationController
  include Webhookable
  before_action :set_survey_response, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /survey_responses
  # GET /survey_responses.json
  def index
    @survey_responses = SurveyResponse.all
  end

  # GET /survey_responses/1
  # GET /survey_responses/1.json
  def show
  end

  # GET /survey_responses/new
  def new
    @survey_response = SurveyResponse.new
  end

  # GET /survey_responses/1/edit
  def edit
  end

  # POST /survey_responses
  # POST /survey_responses.json
  def create
    @survey_response = SurveyResponse.new(survey_response_params)

    respond_to do |format|
      if @survey_response.save
        format.html { redirect_to @survey_response, notice: 'Survey response was successfully created.' }
        format.json { render :show, status: :created, location: @survey_response }
      else
        format.html { render :new }
        format.json { render json: @survey_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_responses/1
  # PATCH/PUT /survey_responses/1.json
  def update
    respond_to do |format|
      if @survey_response.update(survey_response_params)
        format.html { redirect_to @survey_response, notice: 'Survey response was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey_response }
      else
        format.html { render :edit }
        format.json { render json: @survey_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_responses/1
  # DELETE /survey_responses/1.json
  def destroy
    @survey_response.destroy
    respond_to do |format|
      format.html { redirect_to survey_responses_url, notice: 'Survey response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sms
    participant = SurveyResponse.find_by_from(params["From"])
    if participant.blank?
      SurveyResponse.create(from: params["From"])
      response = Twilio::TwiML::Response.new do |r|
        r.message do |message|
          message.body("What do you love about Duxbury?")
        end
      end
      render_twiml response
    elsif participant.try(:question1)
      participant.question2 = params["Body"]
      participant.save!
      response = Twilio::TwiML::Response.new do |r|
        r.message do |message|
          message.body("Thank you for your participation")
        end
      end
      render_twiml response
    elsif participant.try(:from)
      participant.question1 = params["Body"]
      participant.save!
      response = Twilio::TwiML::Response.new do |r|
        r.message do |message|
          message.body("What do you think could be improved?")
        end
      end
      render_twiml response
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_response
      @survey_response = SurveyResponse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_response_params
      params.fetch(:survey_response, {})
    end
end
