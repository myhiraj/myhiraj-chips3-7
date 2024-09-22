class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def guess my_guess
    if my_guess.nil?
      raise ArgumentError.new()
    end
    if my_guess == ''
      raise ArgumentError.new()
    end
    if @guesses.include?(my_guess.downcase) or @wrong_guesses.include?(my_guess.downcase)
      return false
    end
    if @word.each_char{|w| 
      if w.include?(my_guess.downcase)
        @guesses.concat(my_guess.downcase)
        return true
      end
      }
    end
    if my_guess.match?(/[a-zA-Z]/)
      @wrong_guesses.concat(my_guess.downcase)
      return true
    end
    if my_guess.match?(/[^a-zA-Z]/)
      raise ArgumentError.new()
    end
  end

  def word_with_guesses
    if @guesses == ''
      return '-' * (@word.length)
    end
    return @word.tr("^#{@guesses}",'-')
  end

  def check_win_or_lose
    if self.word_with_guesses == @word
      return :win
    elsif wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
