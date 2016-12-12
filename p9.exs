defmodule P9 do
  def solve(input) do
    File.read!(input)
    |> len()
  end
  def len(binary), do: len(binary, 0)
  def len(<<>>, acc), do: acc
  def len(<<?\n>>, acc), do: acc
  def len(<<?(, rest::binary>>, acc) do
    {a, <<?x, rest::binary>>} = Integer.parse(rest)
    {b, <<?), rest::binary>>} = Integer.parse(rest)
    <<seq::bytes-size(a), rest::binary>> = rest
    len(rest, len(seq) * b + acc)
  end
  def len(<<_, rest::binary>>, acc), do: len(rest, 1 + acc)
end
