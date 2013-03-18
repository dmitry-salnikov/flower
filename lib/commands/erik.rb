# encoding: utf-8

class Erik < Flower::Command
  listen_to /erik.*(deploy|deploya|kaos|deadline|möte|ass|fuck)|(deploy|deploya|kaos|deadline|möte).*erik/i

  def self.description
    "Erik punchlines"
  end

  def self.listen(message)
    message.say("#{message.sender[:nick]}, " + line[rand(line.size)], :mention => message.user_id)
  end

  def self.line
    [
      'jag kanske bara kaosar här, men...',
      'githubba gemsarna!',
      'tryck upp den rakt upp i mastern!',
      'vi kan ta ett möte om det senare.',
      'jag kommer in vid kl 10, vi kan väl ta det därefter?',
      'god wills it!',
      'det är nåt fel på Google Excel!'
    ]
  end
end

