class SchedulesController < ApplicationController
  def index
    @schedule = current_user.schedules.new
    @schedules = current_user.schedules.includes(:recipe)
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today

    @recipes = if params[:query].present?
                current_user.favorites.where("name ILIKE ?", "%#{params[:query]}%")
              else
                current_user.favorites
              end
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)
    @recipes = current_user.recipes
    if @schedule.save
      @schedules = current_user.schedules.includes(:recipe)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to schedules_path(start_date: @schedule.date.beginning_of_month), status: :see_other }
      end
    else
      render :index, status: :unprocessable_content
    end
  end

  def generate_ai
    SchedulerbroadcastJob.perform_later(current_user.id, params.to_unsafe_h)

    respond_to do |format|
      format.turbo_stream # pode ter um spinner ou aviso "gerando receitas..."
      format.html { redirect_to schedules_path, notice: "Gerando receitas, isso pode levar alguns segundos..." }
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:date, :recipe_id)
  end
end
