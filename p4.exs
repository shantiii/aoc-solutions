defmodule P4 do
  def solve(input) do
    File.stream!(input)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&valid?/1)
    |> Stream.map(fn %{sector: sector} -> sector end)
    |> Enum.sum()
  end
  def solve2(input) do
    File.stream!(input)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&valid?/1)
    |> Stream.map(&decipher/1)
    |> Enum.to_list()
  end
  def parse_line(line) do
    line
    |> parse_chars(%{data: %{}, raw: line})
  end
  def parse_chars(<<?[, sum::bytes-5, ?], _::binary>>, acc) do
    Map.put(acc, :checksum, sum)
  end
  def parse_chars(<<?-, rest::binary>>, acc), do: parse_chars(rest, acc)
  def parse_chars(<<c, rest::binary>>, acc) when  c in ?0..?9 do
    parse_chars(rest, Map.update(acc, :sector, c-?0, &(&1*10 + c-?0)))
  end
  def parse_chars(<<c, rest::binary>>, acc) when c in ?a..?z do
    parse_chars(rest, %{acc | data: Map.update(acc.data, c, 1, &(&1+1))})
  end
  def valid?(%{data: data, checksum: provided}) do
    require Logger
    computed =
      ?a..?z
      |> Enum.sort_by(&Map.get(data, &1, 0), &>=/2)
      |> Enum.take(5)
    computed == to_charlist(provided)
  end
  def decipher(%{sector: sector, raw: raw}) do
    import Enum, only: [map: 2]
    clear =
      raw
      |> to_charlist()
      |> map(fn letter when letter in ?a..?z -> rem(letter - ?a + sector, 26) + ?a
                letter -> letter end)
  end
end
