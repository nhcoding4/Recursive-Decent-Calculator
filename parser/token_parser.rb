# frozen_string_literal: true

require './tokens/tokens'
require './lexer/lexer'

# Turns raw tokens into expression
class TokenParser
  def initialize(raw_tokens)
    @raw_tokens = raw_tokens
    @total_tokens = raw_tokens.length
    @current_token = nil
    @current = 0
    @peek = 0
    @parsed_tokens = nil

    read_token
    @parsed_tokens = parse_expr
  end

  attr_reader :parsed_tokens

  # --------------------------------------------------------------------------------------------------------------------

  def parse_expr
    term = parse_term

    loop do
      return term unless @current_token.instance_of?(Operator)

      if @current_token.value == '+'
        term = parse_expr_addition(term)
      elsif @current_token.value == '-'
        term = parse_expr_subtraction(term)
      else
        return term
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_expr_addition(term)
    read_token
    term2 = parse_term
    Add.new(term, term2)
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_expr_subtraction(term)
    read_token
    term2 = parse_term
    Subtract.new(term, term2)
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_factor
    if @current_token.instance_of?(TokenNumber)
      @current_token
    elsif @current_token.instance_of?(Operator)
      return parse_paren if @current_token.value == '('

      if @current_token.value == '-'
        read_token
        Negative.new(parse_factor)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_paren
    tokens = parse_paren_sub_tokens
    sub_parser = TokenParser.new(tokens)
    TokenNumber.new(sub_parser.parsed_tokens.eval)
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_paren_sub_tokens
    sub_expr_tokens = []

    loop do
      read_token
      return sub_expr_tokens if @current_token.instance_of?(Operator) && @current_token.value == ')'

      sub_expr_tokens << if @current_token.value == '('
                           parse_paren
                         else
                           @current_token
                         end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_term
    factor = parse_factor

    loop do
      read_token
      return factor unless @current_token.instance_of?(Operator)

      if @current_token.value == '*'
        factor = parse_term_multiply(factor)
      elsif @current_token.value == '/'
        factor = parse_term_divide(factor)
      else
        return factor
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_term_divide(factor)
    read_token
    factor2 = parse_factor
    Divide.new(factor, factor2)
  end

  # --------------------------------------------------------------------------------------------------------------------

  def parse_term_multiply(factor)
    read_token
    factor2 = parse_factor
    Multiply.new(factor, factor2)
  end

  # --------------------------------------------------------------------------------------------------------------------

  def read_token
    if @peek >= @total_tokens
      @current_token = EOF
    else
      @current = @peek
      @peek += 1
      @current_token = @raw_tokens[@current]
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

end
