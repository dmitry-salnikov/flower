class Volume < Flower::Command
  respond_to "volume", "vol"

  def self.respond(command, up_or_down, sender, flower)
    if up_or_down.empty?
      say_current_vol(flower)
    else
      if validate_message(up_or_down)
        adjust_volume(up_or_down)
        say_current_vol(flower)
      else
        flower.say("Please use only + or -")
      end
    end
  end
  
  def self.description
    "+'s or -'s. The more the merrier."
  end

  private
  def self.validate_message(up_or_down)
    up_or_down =~ /^[\+]+$/ or up_or_down =~ /^[\-]+$/
  end

  def self.adjust_volume(up_or_down)
    amount = up_or_down.length * 10
    new_volume = if up_or_down[0] == "+"
      current_volume + amount
    else
      current_volume - amount
    end
    new_volume = 0 if new_volume < 0
    new_volume = 100 if new_volume > 100
    system("osascript -e 'set volume output volume #{new_volume}'")
  end

  def self.current_volume
    `osascript -e 'get output volume of (get volume settings)'`.strip.to_i
  end

  def self.say_current_vol(flower)
    flower.say("[#{"="*(current_volume/2)}#{"-"*((100-current_volume)/2)}]")
  end
end
