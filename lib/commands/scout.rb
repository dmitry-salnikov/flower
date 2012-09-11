require 'scout_api'
class ScoutStats < Flower::Command
  respond_to "scout"

  SCOUT = Scout::Account.new(Flower::Config.scout_account, Flower::Config.scout_email, Flower::Config.scout_password)

  def self.respond(command, message, sender, flower)
    flower.paste resque
  end

  private

  def self.resque
    [
      "## Resque",
      "Pending: " << Scout::Server.first(:name => 'as2-mediamonitor').metrics.average(:name => 'Resque Monitoring/Pending', :start => Time.now.utc-(60*10), :end => Time.now.utc).to_a.first.last.to_i.to_s,
      "Processed: " << Scout::Server.first(:name => 'as2-mediamonitor').metrics.average(:name => 'Resque Monitoring/Processed', :start => Time.now.utc-(60*10), :end => Time.now.utc).to_a.first.last.to_s << "/sec",
      "Workers: " << Scout::Server.first(:name => 'as2-mediamonitor').metrics.average(:name => 'Resque Monitoring/Workers', :start => Time.now.utc-(60*10), :end => Time.now.utc).to_a.first.last.to_i.to_s
    ]
  end
end
