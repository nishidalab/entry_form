class MembersController < ApplicationController
  include MembersCommon
  before_action :redirect_to_member_login, only: :show
  before_action :redirect_to_member_mypage, only: [:new, :create]

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(params.require(:member).permit(
        :name, :yomi, :email,
        :password, :password_confirmation))
    if @member.save
      redirect_to member_login_url
    else
      render 'new'
    end
  end

  def show
    @member = current_member
  end

  private

    # $B%m%0%$%s$7$F$$$k>l9g%^%$%Z!<%8$X%j%@%$%l%/%H$9$k(B
    def redirect_to_member_mypage
      redirect_member_logged_in(member_mypage_url)
    end

end
