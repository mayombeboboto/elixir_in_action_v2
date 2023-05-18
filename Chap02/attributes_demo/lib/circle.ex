defmodule Circle do
  alias :math, as: Math
  @pi 3.14159

  @spec area(number()) :: integer()
  def area(radius), do: round(Math.pow(radius, 2) * @pi)

  @spec circumference(number()) :: integer()
  def circumference(radius), do: round(2 * radius * @pi)
end
