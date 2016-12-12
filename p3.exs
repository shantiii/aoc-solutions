defmodule P3 do
  def solve(input) do
    to_int = &String.to_integer/1
    File.stream!(input)
    |> Stream.map(&String.split(&1, ~r/ |\n/, trim: true))
    |> Stream.map(&Enum.map(&1, to_int))
    |> Stream.filter(&triangle?/1)
    |> Enum.count()
  end
  def solve2(input) do
    to_int = &String.to_integer/1
    File.stream!(input)
    |> Stream.map(&String.split(&1, ~r/ |\n/, trim: true))
    |> Stream.map(&Enum.map(&1, to_int))
    |> Stream.chunk(3)
    |> Stream.flat_map(&transpose/1)
    |> Stream.filter(&triangle?/1)
    |> Enum.count()
  end
  def transpose(list_of_lists) do
    Enum.reduce(list_of_lists, [[],[],[]], fn [a, b, c], [l1, l2, l3] ->
      [[a|l1], [b|l2], [c|l3]]
    end)
  end
  def triangle?([a, b, c]) when a + b <= c, do: false
  def triangle?([a, b, c]) when b + c <= a, do: false
  def triangle?([a, b, c]) when c + a <= b, do: false
  def triangle?(_), do: true
end
