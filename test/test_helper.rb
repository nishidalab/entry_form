ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

end

class ActionDispatch::IntegrationTest
  # テスト被験者としてログインする
  def log_in_as_participant(participant, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: participant.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  # テスト被験者がログイン中の場合に true を返す
  def is_logged_in_participant?
    !session[:participant_id].nil?
  end

  # テスト実験者としてログインする
  def log_in_as_member(member, password: 'password', remember_me: '1')
    post member_login_path, params: { session: { email: member.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  # テスト実験者がログイン中の場合に true を返す
  def is_logged_in_member?
    !session[:member_id].nil?
  end
end
