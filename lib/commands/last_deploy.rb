require 'time_difference'

class LastDeploy < Flower::Command
  ENVIRONMENTS = ["production", "staging"]

  respond_to "last_deploy"

  def initialize(deploy, environment)
    @deploy, @environment = deploy, environment
  end

  def self.description
    "Get info about the latest deploy to #{ENVIRONMENTS.join("|")}"
  end

  def self.respond(message)
    deploy = latest_deploy(message)
    message.say "Latest deploy finished #{deploy.relative_time_difference} ago with last commit by #{deploy.commit_author}\n#{deploy.url}"
  end

  def relative_time_difference
    TimeDifference.between(finished_at, Time.now).in_general.each do |k,v|
      return "#{v} #{k}" if v > 0
    end
  end

  def commit_author
    @deploy["commit"]["author_name"]
  end

  def url
    @deploy["html_url"]
  end

  private

  def finished_at
    Time.parse(@deploy["finished_at"])
  end

  def self.latest_deploy(message)
    environment = ENVIRONMENTS.include?(message.argument)  ? message.argument : "production"

    response = Typhoeus::Request.get(url(environment))
    body = JSON.parse(response.body)

    new body["deploys"].find{|d| d["result"] == "passed"}, environment
  end

  def self.url(environment)
    "https://semaphoreapp.com/api/v1/projects/#{Flower::Config.semaphore["hash_id"]}/servers/#{environment}?auth_token=#{Flower::Config.semaphore["auth_token"]}"
  end
end
