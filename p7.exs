defmodule P7 do
  def solve(input) do
    File.stream!(input)
    |> Stream.filter(&abba?/1)
    |> Enum.count()
  end

  def abba?(binary) do
    abba?(binary, :normal, false)
  end
  def abba?(<<?[, rest::binary>>, :normal, possible) do
    abba?(rest, :hypernet, possible)
  end
  def abba?(<<?], rest::binary>>, :hypernet, possible) do
    abba?(rest, :normal, possible)
  end
  def abba?(<<a, b, b, a, rest::binary>>, :normal, possible) when b != a do
    abba?(rest, :normal, true)
  end
  def abba?(<<a, b, b, a, rest::binary>>, :hypernet, _possible) when b != a do
    false
  end
  def abba?(<<_, rest::binary>>, mode, possible) do
    abba?(rest, mode, possible)
  end
  def abba?(<<>>, _, possible) do
    possible
  end
end

defmodule P72 do
  def solve(input) do
    File.stream!(input)
    |> Stream.filter(&ssl?/1)
    |> Enum.count()
  end

  def ssl?(binary) do
    ssl?(binary, :normal, %{aba: MapSet.new(), bab: MapSet.new()})
  end
  def ssl?(<<?[, rest::binary>>, :normal, state) do
    ssl?(rest, :hypernet, state)
  end
  def ssl?(<<?], rest::binary>>, :hypernet, state) do
    ssl?(rest, :normal, state)
  end
  def ssl?(<<a, b, a, rest::binary>>, :normal, state) when a != b do
    if MapSet.member?(state.bab, <<b, a, b>>) do
      true
    else
      ssl?(<<b, a, rest::binary>>, :normal, %{state | aba: MapSet.put(state.aba, <<a, b, a>>)})
    end
  end
  def ssl?(<<b, a, b, rest::binary>>, :hypernet, state) when a != b do
    if MapSet.member?(state.aba, <<a, b, a>>) do
      true
    else
      ssl?(<<a, b, rest::binary>>, :hypernet, %{state | bab: MapSet.put(state.bab, <<b, a, b>>)})
    end
  end
  def ssl?(<<_, rest::binary>>, mode, state), do: ssl?(rest, mode, state)
  def ssl?(<<>>, _mode, _state), do: false
end
