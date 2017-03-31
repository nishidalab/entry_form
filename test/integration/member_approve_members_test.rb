require 'test_helper'

class MemberApproveMembersTest < ActionDispatch::IntegrationTest
  def setup
    @test = members(:one)
    @admin = members(:admin)
  end

  test "approve members shows normal members logged in as admin member" do
    log_in_as_member @admin
    get member_approve_path

    normal_members = Member.where(admin: false)

    normal_members.each do |normal_member|
      assert_select "a[href=?]", update_member_admin_path(normal_member.id)
    end

    patch update_member_admin_path(@test.id)
    get member_approve_path
    normal_members.each do |normal_member|
      if normal_member.id == @test.id
        assert_select "a[href=?]", update_member_admin_path(normal_member.id), count: 0
      else
        assert_select "a[href=?]", update_member_admin_path(normal_member.id)
      end
    end
  end
end
