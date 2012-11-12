# encoding: UTF-8
class SoundCommand < Flower::Command

  def self.subclasses
      ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  private

  def self.play_file(file_name, lower_spotify = true)
    if lower_spotify
      SpotifyCommand.lower_spotify do
        system_play_file(file_name) unless silenced?
      end
    else
      system_play_file(file_name) unless silenced?
    end
  end

  def self.system_play_file(file_name)
    system "afplay", File.expand_path(File.join(__FILE__, "..", "..", "..", "extras", file_name))
  end

  def self.silenced_at=(t)
    @@silenced_at = t
  end

  def self.silenced_at
    @@silenced_at ||= Time.now - 1
  end

  def self.silenced?
    silenced_at > Time.now
  end
end
