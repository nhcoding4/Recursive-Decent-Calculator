# frozen_string_literal: true

# Takes input from the user
class Input
  def initialize(prompt)
    @input = ''
    print prompt
    read
  end

  attr_reader :input

  # --------------------------------------------------------------------------------------------------------------------

  def read
    @input = gets.chomp
  end

  # --------------------------------------------------------------------------------------------------------------------

end
