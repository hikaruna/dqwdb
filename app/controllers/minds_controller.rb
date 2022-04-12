class MindsController < ApplicationController
  before_action :set_mind, only: %i[ show edit update destroy ]

  # GET /minds or /minds.json
  def index
    @minds = Mind.all
  end

  # GET /minds/1 or /minds/1.json
  def show
  end

  # GET /minds/new
  def new
    @mind = Mind.new
  end

  # GET /minds/1/edit
  def edit
  end

  # POST /minds or /minds.json
  def create
    @mind = Mind.new(mind_params)

    respond_to do |format|
      if @mind.save
        format.html { redirect_to mind_url(@mind), notice: "Mind was successfully created." }
        format.json { render :show, status: :created, location: @mind }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mind.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /minds/1 or /minds/1.json
  def update
    respond_to do |format|
      if @mind.update(mind_params)
        format.html { redirect_to mind_url(@mind), notice: "Mind was successfully updated." }
        format.json { render :show, status: :ok, location: @mind }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mind.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /minds/1 or /minds/1.json
  def destroy
    @mind.destroy

    respond_to do |format|
      format.html { redirect_to minds_url, notice: "Mind was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mind
      @mind = Mind.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mind_params
      params.require(:mind).permit(:no, :name)
    end
end
