# frozen_string_literal: true

require './tokens/tokens'

EOF = nil

# Splits raw input into tokens
class Lexer
  def initialize(input)
    @input = input
    @input_length = input.length
    @ch = nil
    @current = 0
    @peek = 0
    @tokens = []
    @errors = []
    @opened_paren = 0

    run_lexer
  end

  attr_reader :tokens, :errors

  # --------------------------------------------------------------------------------------------------------------------

  def create_tokens
    until @ch == EOF
      case @ch
      when '0'..'9'
        create_number_token
      when '+', '-', '/', '*', '(', ')'
        create_operator_token
      else
        other_operation
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def create_number_token
    start = @current

    read_char until @ch == EOF || !digit?(@ch)

    @tokens << if @ch != EOF && !digit?(@ch)
                 TokenNumber.new(@input[start..@current - 1])
               else
                 TokenNumber.new(@input[start..@current])
               end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def create_operator_token
    paren_checks
    @tokens << Operator.new(@ch)
    read_char
  end

  # --------------------------------------------------------------------------------------------------------------------

  def digit?(character)
    character == '.' || Float(character) >= 0 && Float(character) <= 9
  rescue ArgumentError || TypeError
    nil
  end

  # --------------------------------------------------------------------------------------------------------------------

  def other_operation
    @ch == ' ' ? nil : @errors << "Invalid token at position #{@current + 1}: #{@input[@current]}"
    read_char
  end

  # --------------------------------------------------------------------------------------------------------------------

  def paren_checks
    @errors << "Invalid parenthesis at position #{@current + 1}: #{@input[@current]}" if @ch == ')' && @opened_paren < 1
    @opened_paren += 1 if @ch == '('
    @opened_paren -= 1 if @ch == ')'
  end

  # --------------------------------------------------------------------------------------------------------------------

  def lexing_errors
    @errors << 'Unclosed opening parenthesis' if @opened_paren != 0
    @errors.each { |error| puts error }
  end

  # --------------------------------------------------------------------------------------------------------------------

  def print_tokens
    @tokens.each do |token|
      puts token.to_string
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def read_char
    if @peek >= @input_length
      @ch = EOF
    else
      @current = @peek
      @peek += 1
      @ch = @input[@current]
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def run_lexer
    read_char
    create_tokens
    lexing_errors
  end

  # --------------------------------------------------------------------------------------------------------------------

end
