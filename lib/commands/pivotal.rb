
# encoding: utf-8
class Pivotal < Flower::Command
  require 'pivotal-tracker'

  respond_to "p"
  PivotalTracker::Client.token('dev+flower@mynewsdesk.com', 'flowerbot')

  def self.description
    "!p projectname user|unscheduled|unstarted|started|finished|delivered|accepted|rejected \n Default user:all, state:unstarted"
  end

  def self.respond(command, message, sender, flower)
    @projects = PivotalTracker::Project.all
    @parts = message.split
    flower.say("You have to at least state a project") and return unless @parts.length > 0
    if @parts.first.is_a?(Numeric)
      story flower
    else
      project flower
    end
  end

  def self.project(flower)
    @project = @projects.find {|project| project.name.downcase.include? @parts.first.downcase }
    flower.say("No matching projects") and return if @project.nil?

    stories = @project.stories.all(:owner => @parts[1], :state => @parts[2])
    unless stories.length.zero?
      flower.paste(stories.map { |story| story.name + "\n"+story.url })
    else
      flower.paste('No matching stories')
    end
  end

  def self.story

  end
end
