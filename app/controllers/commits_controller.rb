class CommitsController < ApplicationController
  before_action :set_commit, only: [:show, :edit, :update, :destroy]

  # GET /commits
  # GET /commits.json
  def index
    @recent_commits = Commit.where("created_at > ?", 1.day.ago)
    @old_commits = Commit.where("created_at < ?", 1.day.ago)
  end

  # GET /commits/1
  # GET /commits/1.json
  def show
    begin
      redis_connection = RedisConnection.new
      @pending_responses = redis_connection.all
    rescue Redis::CannotConnectError
      @pending_responses = []
      @redis_down = true
    end
    @grouped_responses = @commit.responses.includes(:url).group_by(&:url)
    @responses = @commit.responses.order(time: :desc)
  end

  # GET /commits/new
  def new
    @commit = Commit.new
  end

  # GET /commits/1/edit
  def edit
  end

  # POST /commits
  # POST /commits.json
  def create
    @commit = Commit.new(commit_params)

    respond_to do |format|
      if @commit.save
        format.html { redirect_to @commit, notice: 'Commit was successfully created.' }
        format.json { render :show, status: :created, location: @commit }
      else
        format.html { render :new }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commits/1
  # PATCH/PUT /commits/1.json
  def update
    respond_to do |format|
      if @commit.update(commit_params)
        format.html { redirect_to @commit, notice: 'Commit was successfully updated.' }
        format.json { render :show, status: :ok, location: @commit }
      else
        format.html { render :edit }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commits/1
  # DELETE /commits/1.json
  def destroy
    @commit.destroy
    respond_to do |format|
      format.html { redirect_to commits_url, notice: 'Commit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def request_sync
    SyncRequestsWorker.perform_async
    respond_to do |format|
      format.html { redirect_to commits_url, notice: 'Requests sync initiated.' }
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commit
      @commit = Commit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commit_params
      params.fetch(:commit, {})
    end
end
