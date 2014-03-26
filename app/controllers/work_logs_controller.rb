class WorkLogsController < ApplicationController
  before_action :set_work_log, only: [:show, :edit, :update, :destroy]

  # GET /work_logs
  # GET /work_logs.json
  def index
    @work_logs = WorkLog.all
  end

  # GET /work_logs/1
  # GET /work_logs/1.json
  def show
    @tasks = current_user.assignments
  end

  # GET /work_logs/new
  def new
    unless params[:date].present?
      @date = Date.today
    else
      @date = params[:date].to_date
    end
    @entries = Task.where('start_date <= ? && end_date >= ?',@date.end_of_day,@date.beginning_of_day)
    @date = params[:date].present? ? params[:date].to_date : Date.today
    @work_log = WorkLog.new(:date=>@date)
    @hours = @work_log.minutes.to_i/60
    @mins = @work_log.minutes.to_i%60
  end

  # GET /work_logs/1/edit
  def edit
    @date = @work_log.date
    @entries = Task.where('start_date <= ? && end_date >= ?',@work_log.date.end_of_day,@work_log.date.beginning_of_day)
    @hours = @work_log.minutes.to_i/60
    @mins = @work_log.minutes.to_i%60
  end

  # POST /work_logs
  # POST /work_logs.json
  def create
    @work_log = WorkLog.new(work_log_params)
    @work_log.user_id = current_user.id
    @work_log.minutes = params[:work_log][:hours].to_i*60+params[:work_log][:mins].to_i
    respond_to do |format|
      if @work_log.save
        format.html { redirect_to @work_log, notice: 'Work log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @work_log }
      else
        format.html { render action: 'new' }
        format.json { render json: @work_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_logs/1
  # PATCH/PUT /work_logs/1.json
  def update
    @work_log.minutes = params[:work_log][:hours].to_i*60+params[:work_log][:mins].to_i
    respond_to do |format|
      if @work_log.update(work_log_params)
        format.html { redirect_to @work_log, notice: 'Work log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @work_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_logs/1
  # DELETE /work_logs/1.json
  def destroy
    @work_log.destroy
    respond_to do |format|
      format.html { redirect_to work_logs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_log
      @work_log = WorkLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_log_params
      params.require(:work_log).permit(:user_id, :name, :description, :start_time, :date, :end_time, :is_deleted,:task_id)
    end
end
