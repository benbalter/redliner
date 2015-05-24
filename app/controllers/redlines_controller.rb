class RedlinesController < ApplicationController
  before_action :set_redline, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index, :edit, :new, :create]

  # GET /redlines
  # GET /redlines.json
  def index
    @redlines = Redline.all
  end

  # GET /redlines/1
  # GET /redlines/1.json
  def show
    authenticate_user! if @redline.user.login
    sign_in @redline.user
  end

  # GET /redlines/new
  def new
    @redline = Redline.new
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

  def update
    id = @redline.submit!({
      :contents   => params[:contents],
      :commit_msg => params[:commit_msg]
    })
    if @redline.client.pullable?
      msg = "Redlines were successfully submitted as <a href=\"#{@redline.repository.url}/issues/#{id}\">#{@redline.repository.nwo}##{id}</a>."
    else
      msg = 'Redlines were successfully submitted.'
    end
    redirect_to redline_path, notice: msg
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redline
      @redline = Redline.find_by(key: params[:key])
      client = Client.new :token => session[:token], :repo => @redline.document.repository
      @redline.client = client
      @redline.document.client = client
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redline_params
      params.require(:redline).permit(:key)
    end

    def authenticate
      redirect_to auth_failure_path, status: 401 unless current_user && current_user.admin?
    end
end
