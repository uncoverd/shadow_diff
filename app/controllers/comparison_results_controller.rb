class ComparisonResultsController < ApplicationController
  before_action :set_comparison_result, only: [:show, :edit, :update, :destroy]

  # GET /comparison_results
  # GET /comparison_results.json
  def index
    @comparison_results = ComparisonResult.all
  end

  # GET /comparison_results/1
  # GET /comparison_results/1.json
  def show
  end

  # GET /comparison_results/new
  def new
    @comparison_result = ComparisonResult.new
  end

  # GET /comparison_results/1/edit
  def edit
  end

  # POST /comparison_results
  # POST /comparison_results.json
  def create
    @comparison_result = ComparisonResult.new(comparison_result_params)

    respond_to do |format|
      if @comparison_result.save
        format.html { redirect_to @comparison_result, notice: 'Comparison result was successfully created.' }
        format.json { render :show, status: :created, location: @comparison_result }
      else
        format.html { render :new }
        format.json { render json: @comparison_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comparison_results/1
  # PATCH/PUT /comparison_results/1.json
  def update
    respond_to do |format|
      if @comparison_result.update(comparison_result_params)
        format.html { redirect_to @comparison_result, notice: 'Comparison result was successfully updated.' }
        format.json { render :show, status: :ok, location: @comparison_result }
      else
        format.html { render :edit }
        format.json { render json: @comparison_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comparison_results/1
  # DELETE /comparison_results/1.json
  def destroy
    @comparison_result.destroy
    respond_to do |format|
      format.html { redirect_to comparison_results_url, notice: 'Comparison result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comparison_result
      @comparison_result = ComparisonResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comparison_result_params
      params.require(:comparison_result).permit(:response_id, :rule_id, :index)
    end
end
