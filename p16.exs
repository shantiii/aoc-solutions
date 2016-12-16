defmodule P16 do
  def solve(input) do
    input = Enum.map(input, &(&1-?0))
    Stream.iterate(input, &iterate/1)
    |> Stream.drop_while(fn x -> length(x) < 35651584 end)
    |> Enum.take(1)
    |> hd()
    |> Enum.take(35651584)
    |> checksum()
    |> Enum.join()
  end
  def iterate(a) do
    b = a |> Enum.reverse() |> Enum.map(fn 0 -> 1
      1 -> 0 end)
    a ++ [0 | b]
  end
  def checksum(list) when rem(length(list), 2) == 0 do
    new =
    list
    |> Enum.chunk(2)
    |> Enum.map(fn [a, b] ->
      if a == b do
      1
    else
      0
    end
    end)
    checksum(new)
  end
  def checksum(list), do: list
end
