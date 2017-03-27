class MemberActivationsController < ApplicationController
  include AccountsCommon

  def edit
    activate_account(user_class: :member, e: params[:e], t: params[:t])
  end
end
