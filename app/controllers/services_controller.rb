class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_service, only: [:show, :edit, :update, :destroy, :go]

  # GET /services
  # GET /services.json
  def index
    @services = @project.services.includes(:provider)
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @tokens = @service.tokens.order(created_at: :desc)
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = @project.services.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to [@project, @service] }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to [@project, @service], notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to project_services_url(@project), notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def go
    session[:service_id] = @service.id
    redirect_to "/auth/#{@service.provider.omniauth_name}"
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.friendly.find(params[:project_id])
      @services = @project.services.includes(:provider)
    end

    def set_service
      @service = @project.services.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:provider_id, :api_key, :api_secret, :scope)
    end
end
