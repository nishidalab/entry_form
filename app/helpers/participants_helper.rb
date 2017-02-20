module ParticipantsHelper
  # 応募の受付状態に対応するカレンダー表示タイトルと色コードを返す
  def get_title_and_color(status, title)
    case status
      when 1
        return [title, '#428bca']
      else
        return ["【申請中】#{title}", '#555555']
    end
  end
end
