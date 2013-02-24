desc "send emails from queue"
task :send_mails => :environment do
  n = 0
  errs = 0
  MailQueue.all.each do |m|
    begin
      LanMailer.general_mail(m).deliver
      m.delete
      n += 1
    rescue => e
      m.error = e.message
      m.save
      errs += 1
    end
  end
  LanMailer.task_done("sent #{n} mails, total of #{errs} errors").deliver
end
