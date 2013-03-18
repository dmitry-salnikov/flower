class Selfupdate < Flower::Command
  respond_to "selfupdate"
  def self.respond(message)
    if message.argument == "reboot"
      message.say("Rebooting...")
      exec("rake run")
    else
      system("git fetch")
      diff = `git log --decorate --left-right --graph --cherry-pick --oneline master...origin/master`

      if diff.empty?
        message.say("No updates found. No need to reboot!")
      else
        message.say("Applying updates and rebooting:")
        message.paste(diff)
        system("git pull --rebase")
        exec("rake run")
      end
    end
  end

  def self.description
    "Update bot firmware. Pass 'reboot' to reboot only."
  end
end
