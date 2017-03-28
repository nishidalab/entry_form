class ParticipantActivationsController < ApplicationController
  include AccountsCommon

  def edit
    activate_account(user_class: :participant, e: params[:e], t: params[:t])
  end
end
