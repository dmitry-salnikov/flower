class Pair < Flower::Command
  respond_to "pair"

  EMOTIONS = [
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/dinosaur-hands.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/howiprogram.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/high-five.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/the-word.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/refute.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/whoawhoa.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/firstiwas.gif',
    'http://www.trainsignal.com/blog/wp-content/uploads/peepcode/2013/charismatic-duo/img/look.gif'
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
