class MemberController < ApplicationController
#  before_action :redirect_to_login, only: :show
#  before_action :redirect_to_mypage, only: [:new, :create]

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(params.require(:member).permit(
        :name, :yomi, :email,
        :password, :password_confirmation))
    if @member.save
      redirect_to member_url
    else
      render 'new'
    end
  end

  def show
  end

  private

    # $B%m%0%$%s$7$F$$$J$$>l9g%m%0%$%s%Z!<%8$X%j%@%$%l%/%H$9$k(B
#    def redirect_to_login
#      unless logged_in_participant?
#        redirect_to member_login_url
#      end
#    end

    # $B%m%0%$%s$7$F$$$k>l9g%^%$%Z!<%8$X%j%@%$%l%/%H$9$k(B
#    def redirect_to_mypage
#      if logged_in_participant?
#        redirect_to member_mypage_url
#      end
#    end

end
