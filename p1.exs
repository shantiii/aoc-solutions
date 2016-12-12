defmodule P1 do
  def solve(input) do
    File.read!(input)
    |> tokenize()
    |> Stream.scan({:north, {0, 0}},
      fn data, {direction, location} ->
        case data do
          {:left, distance} ->
            new_direction = left(direction)
            {new_direction, move(location, new_direction, distance)}
          {:right, distance} ->
            new_direction = right(direction)
            {new_direction, move(location, new_direction, distance)}
        end
      end)
    |> Stream.take(-1)
    |> Stream.map(fn {_dir, {x, y}} -> abs(x) + abs(y) end)
    |> Enum.to_list()
    |> hd()
  end

  def solve2(input) do
    File.read!(input)
    |> tokenize()
    |> Stream.scan({:north, {0, 0}},
      fn data, {direction, location} ->
        case data do
          {:left, distance} ->
            new_direction = left(direction)
            {new_direction, move(location, new_direction, distance)}
          {:right, distance} ->
            new_direction = right(direction)
            {new_direction, move(location, new_direction, distance)}
        end
      end)
    |> Stream.map(fn {_direction, location} -> location end)
    |> prepend_origin()
    |> Stream.chunk(2, 1)
    |> Stream.map(&expand_segment/1)
    |> Stream.map(&tl/1)
    |> Stream.concat()
    |> Stream.scan({{0, 0}, MapSet.new()}, fn p, {_, set} -> {p, MapSet.put(set, p)} end)
    |> Stream.chunk(2, 1)
    |> Stream.drop_while(fn [{_, set}, {p, _}] -> not MapSet.member?(set, p) end)
    |> Enum.take(1)
    |> Enum.map(fn [{_, _}, {{x, y}, _}] -> abs(x) + abs(y) end)
    |> hd()
  end

  def tokenize(binary), do: tokenize([], binary)
  def tokenize(tokens, <<?\n>>), do: Enum.reverse(tokens)
  def tokenize(tokens, <<?\s, rest::binary>>), do: tokenize(tokens, rest)
  def tokenize(tokens, <<?,, rest::binary>>), do: tokenize(tokens, rest)
  def tokenize(tokens, <<?L, rest::binary>>) do
    {distance, rest} = Integer.parse(rest)
    tokenize([{:left, distance} | tokens], rest)
  end
  def tokenize(tokens, <<?R, rest::binary>>) do
    {distance, rest} = Integer.parse(rest)
    tokenize([{:right, distance} | tokens], rest)
  end

  def move({x, y}, :north, distance), do: {x, y+distance}
  def move({x, y}, :south, distance), do: {x, y-distance}
  def move({x, y}, :east, distance), do: {x+distance, y}
  def move({x, y}, :west, distance), do: {x-distance, y}

  def directions do
    Stream.cycle([:north, :east, :south, :west])
  end
  def right(direction) do
    directions
    |> Stream.drop_while(&(&1 != direction))
    |> Stream.drop(1)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end
  def left(direction) do
    directions
    |> Stream.chunk(2, 1)
    |> Enum.find(fn [l, d] -> d == direction end)
    |> List.first()
  end

  def prepend_origin(enum), do: Stream.concat([{0, 0}], enum)

  def expand_segment([{x1, y1}, {x2, y2}]) do
    if x1 == x2 do
      for y <- y1..y2 do
        {x1, y}
      end
    else # ys are equal
      for x <- x1..x2 do
        {x, y1}
      end
    end
  end
end

P1.solve "Downloads/p1-1input"
