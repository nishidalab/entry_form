class ApplicationsController < ApplicationController
  def index
    @experiments = [
        { id: 1,
          title: 'ゲーム実験',
          describe: 'ゲームをする実験です。',
          requirement: '・京都大学の日本人学生' },
        { id: 2,
          title: '会話実験',
          describe: '会話をする実験です。',
          requirement: "・京都大学の日本人学生\n・男性" }
    ]
    @participant = { id: 1 }
  end

  def new
    experiment_id = params['experiment']
    if experiment_id.nil?
      redirect_to applications_url
      return
    end
    @experiment = { id: 1,
                    title: 'ゲーム実験',
                    describe: 'ゲームをする実験です。' }
    @datetimes = [{ start: DateTime.new(2017, 2, 1, 13, 0), end: DateTime.new(2017, 2, 1, 15, 0) },
                  { start: DateTime.new(2017, 2, 1, 15, 0), end: DateTime.new(2017, 2, 1, 17, 0) },
                  { start: DateTime.new(2017, 2, 2, 9, 0), end: DateTime.new(2017, 2, 2, 11, 0) }]
    @participant = { id: 1 }
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
