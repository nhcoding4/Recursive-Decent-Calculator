# frozen_string_literal: true

require './input/input'
require './lexer/lexer'
require './parser/token_parser'

# Glues all the classes together
class Main
  def initialize
    @prompt = '> '
    main_loop
  end

  # --------------------------------------------------------------------------------------------------------------------

  def main_loop
    how_to_use

    loop do
      input

      next unless lex

      parse
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def how_to_use
    puts 'This calculators supports (), +, -, /.'
    puts 'Press enter to evaluate expressions (no equals).'
    puts 'Enter a blank input to exit.'
  end

  # --------------------------------------------------------------------------------------------------------------------

  def input
    @input = Input.new(@prompt).input
    exit if @input == ''
  end

  # --------------------------------------------------------------------------------------------------------------------

  def lex
    @lexer = Lexer.new(@input)
    @lexer.errors.empty?
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse
    parser = TokenParser.new(@lexer.tokens)
    puts parser.parsed_tokens.eval
  end

  # --------------------------------------------------------------------------------------------------------------------

end

Main.new
