class StackOverflow < Flower::Command
  respond_to "q"
  require 'typhoeus'

  def self.description
    "Ask question to Stack Overflow"
  end

  def self.respond(command, message, sender, flower)
    flower.paste(answer(message))
  end

  def self.answer(query)
    query = URI.escape(query)
    search_url = "https://api.stackexchange.com/2.1/search/advanced?order=desc&sort=relevance&site=stackoverflow&q=#{query}"
    response = Typhoeus::Request.get(search_url)
    questions = JSON.parse(response.body)["items"]
    flower_answer = []
    if questions.length > 0
        questions[0..2].each do |question|
            title = question['title'].gsub(/[^0-9a-z\?\! ]/i, '')
            flower_answer << "# #{title}"
            flower_answer << question['link']
        end
        flower_answer
    else
        ["No answer found. Google it -> https://www.google.com/search?q=#{query}"]
    end
  end
end