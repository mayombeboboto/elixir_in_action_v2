defmodule Geometry do
  @moduledoc """
  Documentation for `Geometry`.
  """
  alias :math, as: Math
  @rectangle :rectangle
  @square :square
  @circle :circle
  @pi 3.14

  def area({@rectangle, side1, side2}), do: side1 * side2
  def area({@circle, radius}), do: Math.pow(radius, 2) * @pi
  def area({@square, side}), do: round(Math.pow(side, 2))
end
