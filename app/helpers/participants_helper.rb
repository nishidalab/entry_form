module ParticipantsHelper
  # 応募の受付状態に対応するカレンダー表示タイトルを返す
  def get_title(status, title)
    case status
      when ApplicationStatus::ACCEPTED
        return title
      else
        return "【申請中】#{title}"
    end
  end
end
