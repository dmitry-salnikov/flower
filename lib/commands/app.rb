require 'github_api'
class App < Flower::Command
  respond_to "app", "diff"

  def self.description
    "Our app"
  end

  def self.respond(message)
    cmd = message.command == "app" ? message.argument.split(" ").first : message.command
    case cmd
    when "diff"
      repo = (message.argument || Flower::Config.github_user).split(" ").last
      message.paste diff(tag(repo), repo)
    end
  end

  def self.diff(from, repo)
    diff = github.repos.commits.compare Flower::Config.github_user, repo, from, 'master'
    ahead = diff.ahead_by
    commits = diff.commits.map do |commit|
      commit.commit.message.split("\n", 2).first
    end
    ["#{repo} is #{ahead} commits ahead", "Deployed #{parse_time_from_tag(from).strftime("%Y-%m-%d %H:%M")}"] + ["https://github.com/#{Flower::Config.github_user}/#{repo}/compare/#{from}...master"] + commits
  end

  private

  def self.parse_time_from_tag(tag)
    Time.parse(Time.parse(tag).strftime("%Y-%m-%d %H:%M")+ " UTC").localtime
  end

  def self.tag(repo)
    tags = github.git_data.references.list Flower::Config.github_user, repo, ref: "tags/production/#{Time.now.year}"
    tags.last.ref[10..-1]
  end

  def self.github
    @@github ||= ::Github.new oauth_token: Flower::Config.github_token
  end
end
