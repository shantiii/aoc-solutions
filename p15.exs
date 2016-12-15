defmodule P15 do
  def solve(input) do
    discs = [{11, 13}, {0, 5}, {11, 17}, {0, 3}, {2, 7}, {17, 19}, {0, 11}]
    Stream.iterate(0, &(&1+1))
    |> Stream.drop_while(&(not valid?(&1, discs, 1)))
    |> Enum.take(1)
  end
  def valid?(time, [], _) do
    true
  end
  def valid?(time, [{initial, mod}|discs], position) do
    if rem(time + initial + position, mod) == 0 do
      valid?(time, discs, position + 1)
    else
      false
    end
  end
end
