class App < Flower::Command
  respond_to "app", "diff"

  def self.description
    "Our app"
  end

  def self.respond(command, message, sender, flower)
    cmd = command == "app" ? message.split(" ").first : command
    case cmd
    when "diff"
      flower.paste(undeployed)
    end
  end

  private

  def self.reset
    `cd #{Flower::Config.git_repo_path} && git fetch origin && git reset --hard origin/master`
  end

  def self.undeployed
    reset
    tag = `cd #{Flower::Config.git_repo_path} && git tag|grep production|tail -n 1`.strip
    undeployed = `cd #{Flower::Config.git_repo_path} && git log --oneline #{tag}..HEAD`.split("\n")
    undeployed << "https://github.com/mynewsdesk/mynewsdesk/compare/#{tag}...master"
  end
end
