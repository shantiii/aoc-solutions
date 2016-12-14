defmodule P14 do
  def solve(input) do
    base =
      Stream.iterate(0, fn n -> n + 1 end)
      |> Stream.map(fn n -> {n, input <> to_string(n)} end)
      |> Stream.map(&map_hash/1)
      |> Stream.filter(fn {_index, hash} -> triple?(hash) end)
    validators =
      base
      |> Stream.filter(fn {_index, hash} -> penta?(hash) end)
      |> Stream.map(fn {index, hash} -> {index, penta_char(hash)} end)
      |> Stream.take(64)
      |> MapSet.new()
    base
    |> Stream.map(fn {index, hash} -> {index, triple_char(hash)} end)
    |> Stream.filter(fn {index, triple} ->
      Enum.any?(validators, fn {p_index, penta} ->
        penta == triple and index < p_index and index >= p_index - 1000
      end)
    end)
    |> Stream.map(fn {index, _} -> index end)
    |> Stream.take(64)
    |> Enum.take(-1)
  end
  def map_hash({index, str}) do
    hash =
      str
      |> :crypto.md5()
      |> Base.encode16(case: :lower)
    {index, hash}
  end
  def triple?(<<_, _>>), do: false
  def triple?(<<x, x, x, _::binary>>), do: true
  def triple?(<<_, rest::binary>>), do: triple?(rest)
  def penta?(<<_, _>>), do: false
  def penta?(<<x, x, x, x, x, _::binary>>), do: true
  def penta?(<<_, rest::binary>>), do: penta?(rest)
  def penta_char(<<x, x, x, x, x, _::binary>>), do: x
  def penta_char(<<_, rest::binary>>), do: penta_char(rest)
  def triple_char(<<x, x, x, _::binary>>), do: x
  def triple_char(<<_, rest::binary>>), do: triple_char(rest)
end
