class RedlinesController < ApplicationController
  before_action :set_redline, only: [:show, :edit, :update, :destroy]

  # GET /redlines
  # GET /redlines.json
  def index
    @redlines = Redline.all
  end

  # GET /redlines/1
  # GET /redlines/1.json
  def show
  end

  # GET /redlines/new
  def new
    @redline = Redline.new
  end

  # GET /redlines/1/edit
  def edit
  end

  # POST /redlines
  # POST /redlines.json
  def create
    @redline = Redline.new(redline_params)

    respond_to do |format|
      if @redline.save
        format.html { redirect_to @redline, notice: 'Redline was successfully created.' }
        format.json { render :show, status: :created, location: @redline }
      else
        format.html { render :new }
        format.json { render json: @redline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redlines/1
  # PATCH/PUT /redlines/1.json
  def update
    respond_to do |format|
      if @redline.update(redline_params)
        format.html { redirect_to @redline, notice: 'Redline was successfully updated.' }
        format.json { render :show, status: :ok, location: @redline }
      else
        format.html { render :edit }
        format.json { render json: @redline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redlines/1
  # DELETE /redlines/1.json
  def destroy
    @redline.destroy
    respond_to do |format|
      format.html { redirect_to redlines_url, notice: 'Redline was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redline
      @redline = Redline.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redline_params
      params.require(:redline).permit(:key, :user_id, :document_id)
    end
end
