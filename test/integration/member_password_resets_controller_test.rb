require 'test_helper'

class MemberPasswordResetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @member = members(:one)
  end

  def submit_reset(email)
    post member_reset_path, params: { password_reset: { email: email } }
  end

  def submit_update(token, email, password, password_confirmation)
    patch member_update_reset_path(token), params: { e: email, member:
        { password: password, password_confirmation: password_confirmation } }
  end

  test "password reset" do
    get member_reset_path
    assert_template 'member_password_resets/new'
    # $B%a!<%k%"%I%l%9$,L58z(B
    submit_reset 'invalid'
    assert_not flash.empty?
    assert_template 'member_password_resets/new'
    # $B%a!<%k%"%I%l%9$,M-8z(B
    submit_reset @member.email
    assert_not_equal @member.reset_digest, @member.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?

    # $B%Q%9%o!<%I:F@_Dj%U%)!<%`(B
    member = assigns(:user)
    assert_redirected_to member_login_url
    # $B%a!<%k%"%I%l%9$,L58z(B
    get member_edit_reset_path(member.reset_token, e: '')
    assert_redirected_to member_login_url
    # $B%"%/%F%#%Y!<%H$5$l$F$$$J$$Ho83<T(B
    member.toggle!(:activated)
    get member_edit_reset_path(member.reset_token, e: member.email.upcase)
    assert_redirected_to member_login_url
    member.toggle!(:activated)
    # $B%H!<%/%s$,L58z(B
    get member_edit_reset_path('invalid', e: member.email.upcase)
    assert_redirected_to member_login_url
    # $B%H!<%/%s$NM-8z4|8B@Z$l(B
    member.update(reset_sent_at: member.reset_sent_at - 3601)
    get member_edit_reset_path(member.reset_token, e: member.email.upcase)
    assert_not flash.empty?
    assert_redirected_to member_reset_url
    member.update(reset_sent_at: member.reset_sent_at + 3601)
    # $BM-8z(B
    get member_edit_reset_path(member.reset_token, e: member.email.upcase)
    assert_template 'member_password_resets/edit'
    assert_select "input[name=e][type=hidden][value=?]", member.email

    # $B%Q%9%o!<%I$H3NG'$,0lCW$7$J$$(B
    submit_update(member.reset_token, member.email.upcase, 'hogehoge', 'fugafuga')
    assert_select 'div#error_explanation'
    # $B%Q%9%o!<%I$,6u(B
    submit_update(member.reset_token, member.email.upcase, '', '')
    assert_select 'div#error_explanation'
    # $B%Q%9%o!<%I$,B-$j$F$J$$(B
    submit_update(member.reset_token, member.email.upcase, 'aaa', 'aaa')
    assert_select 'div#error_explanation'
    # $B%H!<%/%s$NM-8z4|8B@Z$l(B
    member.update(reset_sent_at: member.reset_sent_at - 3601)
    submit_update(member.reset_token, member.email.upcase, 'password', 'password')
    assert_not flash.empty?
    assert_redirected_to member_reset_url
    member.update(reset_sent_at: member.reset_sent_at + 3601)
    # $BM-8z$J%Q%9%o!<%I(B
    submit_update(member.reset_token, member.email.upcase, 'password', 'password')
    assert is_logged_in_member?
    assert_not flash.empty?
    assert_redirected_to member_mypage_url
    assert_nil member.reload.reset_digest
    assert_nil member.reload.reset_sent_at
  end
end
