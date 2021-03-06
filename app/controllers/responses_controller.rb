class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy, :override_response]
  # GET /responses
  # GET /responses.json
  def index
    @commit = Commit.find(params[:commit_id])
    @url = Url.find(params[:url_id])
    @responses = @commit.responses.where(url: @url)
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
    @active_rules = @response.rules.active
    @evaluated_results = @response.comparison_results.includes(:rule).order(line_score: :desc)
  end

  # GET /responses/new
  def new
    @response = Response.new
  end

  # GET /responses/1/edit
  def edit
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = Response.new(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to @response, notice: 'Response was successfully created.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to responses_url, notice: 'Response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def override_response
    if @response.override
      @response.override = false
    else
      @response.override = true
    end
    @response.save
    ScoreUpdateWorker.perform_async
    respond_to do |format|
      format.html { redirect_to commit_url_response_path(params[:commit_id], params[:url_id], params[:id]),
                    notice: 'Response override was successfully toggled, scores should update in a few seconds.' }
      format.json { head :no_content }
    end
  end

  def override_url_response
    @responses = Response.where(commit: Commit.find(params[:commit_id]), url: Url.find(params[:url_id]))
    @responses.each do |response|
      if response.override
        response.override = false
      else
        response.override = true
      end  
      response.save
    end
    ScoreUpdateWorker.perform_async
    respond_to do |format|
      format.html { redirect_to commit_url_responses_path(params[:commit_id], params[:url_id]),
                    notice: ' URL override was successfully toggled, scores should update in a few seconds.' }
      format.json { head :no_content }
    end
  end    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.fetch(:response, {})
    end
end
