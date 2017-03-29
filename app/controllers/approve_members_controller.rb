class ApproveMembersController < ApplicationController
  include MembersCommon
  before_action :redirect_to_member_login
  before_action :redirect_to_member_mypage_exclude_admin

  def show
    @normal_members = Member.where(admin: false)
  end

  def update
    if params[:id].nil?
      flash[:warning] = '不正なリクエストです。'
    else
      normal_member = Member.find_by_id(params[:id])
      if !normal_member.nil? && normal_member.update(admin: true)
        flash[:success] = "#{normal_member.name} の承認に成功しました。"
      else
        flash[:warning] = "承認に失敗しました。"
      end
      redirect_to member_approve_url
    end
  end
end
