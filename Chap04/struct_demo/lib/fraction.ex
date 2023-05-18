defmodule Fraction do
  @moduledoc """
  Documentation for `Fraction`.
  """
  defstruct numerator: nil, denominator: nil

  def new(numerator, denominator) do
    %Fraction{
      numerator: numerator,
      denominator: denominator
    }
  end

  def value(%Fraction{
        numerator: numerator,
        denominator: denominator
      }) do
    numerator / denominator
  end

  def add(
        %Fraction{
          numerator: numerator1,
          denominator: denominator1
        },
        %Fraction{
          numerator: numerator2,
          denominator: denominator2
        }
      ) do
    numerator = numerator1 * denominator2 + numerator2 * denominator1
    denominator = denominator1 * denominator2
    numerator / denominator
  end
end
