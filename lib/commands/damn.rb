class Damn < Flower::Command
  respond_to "damn"

  DAMN = %w(
    http://1.bp.blogspot.com/-PrvQzCwG63k/T2Z9fpQ-OOI/AAAAAAAAA1o/iGzc2P7v9MY/s1600/friday-damn-gif.gif
    http://25.media.tumblr.com/tumblr_m6960fmvqH1rqfhi2o1_500.gif
    http://media.tumblr.com/tumblr_lr6lhcxgpw1qbklpr.gif
    http://24.media.tumblr.com/tumblr_m7kfreNoJH1qfjbk4o1_400.gif
    http://media.tumblr.com/tumblr_m7robiO42n1r71zck.gif
  )

  class << self
    def description
      "DAMN!!"
    end

    def respond message
      message.say DAMN.sample
    end
  end
end
