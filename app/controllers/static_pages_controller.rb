class StaticPagesController < ApplicationController
  def home
    # とりあえずこうしとく
    redirect_to register_url
  end
end
