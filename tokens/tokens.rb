# frozen_string_literal: true

# ----------------------------------------------------------------------------------------------------------------------

# Add expr: 1 + 1
class Add
  def initialize(left, right)
    @left = left
    @right = right
  end

  def to_string
    "(#{@left.to_string} + #{@right.to_string})"
  end

  def eval
    @left.eval + @right.eval
  end
end

# ----------------------------------------------------------------------------------------------------------------------

# Subtract expr: 1 - 1
class Subtract
  def initialize(left, right)
    @left = left
    @right = right
  end

  def to_string
    "(#{@left.to_string} - #{@right.to_string})"
  end

  def eval
    @left.eval - @right.eval
  end
end

# ----------------------------------------------------------------------------------------------------------------------

# Divide expr: 1 / 1
class Divide
  def initialize(left, right)
    @left = left
    @right = right
  end

  def to_string
    "(#{@left.to_string} / #{@right.to_string})"
  end

  def eval
    @left.eval / @right.eval
  end
end

# ----------------------------------------------------------------------------------------------------------------------

# Multiply expr: 1 * 1
class Multiply
  def initialize(left, right)
    @left = left
    @right = right
  end

  def to_string
    "(#{@left.to_string} * #{@right.to_string})"
  end

  def eval
    @left.eval * @right.eval
  end
end

# ----------------------------------------------------------------------------------------------------------------------

# Negative expr: -1
class Negative
  def initialize(right)
    @right = right
  end

  def to_string
    "(-#{@right.to_string})"
  end

  def eval
    -@right.eval
  end
end

# ----------------------------------------------------------------------------------------------------------------------

# Numbers: Raw number literals.
class TokenNumber
  def initialize(value)
    @value = value
  end

  attr_reader :value

  def to_string
    @value
  end

  def eval
    Float(@value)
  end
end

# ----------------------------------------------------------------------------------------------------------------------

# Operators: +, -, /, *, () supported
class Operator
  def initialize(value)
    @value = value
  end

  attr_reader :value

  def to_string
    String(@value)
  end
end

# ----------------------------------------------------------------------------------------------------------------------
