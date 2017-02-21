class ApplicationMailer < ActionMailer::Base
  default from: '"京都大学 西田研究室" <no-reply@ii.ist.i.kyoto-u.ac.jp>'
          #bcc:  'experiment@ii.ist.i.kyoto-u.ac.jp'
  layout 'mailer'
end
