class Pair < Flower::Command
  respond_to "pair"

  EMOTIONS = [
    "https://peepcode.com/blog/2013/charismatic-duo/img/dinosaur-hands.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/howiprogram.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/howiprogram.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/awyep.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/the-word.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/refute.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/whoawhoa.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/firstiwas.gif",
    "https://peepcode.com/blog/2013/charismatic-duo/img/look.gif"
  ]

  class << self
    def description
      "Pairing gifs"
    end

    def respond message
      message.say EMOTIONS.sample
    end
  end
end
