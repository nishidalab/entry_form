class ApplicationsController < ApplicationController
  def index
    @experiments = Experiment.all
    @participant = Participant.find(1)
  end

  def new
    experiment_id = params['experiment']
    if experiment_id.nil? || Experiment.find(experiment_id).nil?
      redirect_to applications_url
      return
    end
    @experiment = Experiment.find(experiment_id)
    @slots = @experiment.slots.all
    @participant = Participant.find(1)
  end

  def create
    redirect_to applications_url
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
