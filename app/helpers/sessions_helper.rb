module SessionsHelper
  # 渡された被験者でログインする
  def log_in_participant(participant)
    session[:participant_id] = participant.id
  end

  # 渡された被験者を永続的セッションに保存する
  def remember_participant(participant)
    participant.remember
    cookies.permanent.signed[:participant_id] = participant.id
    cookies.permanent[:remember_token] = participant.remember_token
  end

  # 永続的セッションを破棄する
  def forget_participant(participant)
    participant.forget
    cookies.delete(:participant_id)
    cookies.delete(:remember_token)
  end

  # ログインしている被験者を返す。ログインしていないなら nil を返す。
  def current_participant
    if id = session[:participant_id]
      @participant ||= Participant.find_by(id: id)
    elsif id = cookies.signed[:participant_id]
      participant = Participant.find_by(id: id)
      if participant && participant.authenticated?(cookies[:remember_token])
        log_in_participant participant
        @participant = participant
      end
    end
  end

  # 被験者としてログインしていれば true を返す。
  def logged_in_participant?
    !current_participant.nil?
  end

  # 被験者をログアウトする。
  def log_out_participant
    forget_participant(@participant)
    session.delete(:participant_id)
    @participant = nil
  end
end