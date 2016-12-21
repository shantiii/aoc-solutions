defmodule P21 do
  def solve input do
    File.stream!(input)
    |> Enum.reduce("abcdefgh", &dothing/2)
  end
  def solve2 input do
    File.stream!(input)
    |> Enum.reverse()
    |> Enum.reduce("fbgdceah", &part2/2)
  end

  def dothing("swap position " <> rest, state) do
    {x, " with position " <> rest} = Integer.parse rest
    {y, _} = Integer.parse rest
    swap_pos(state, min(x, y), max(x, y))
  end
  def dothing("swap letter " <> rest, state) do
    <<x::bytes-1, rest::binary>> = rest
    " with letter " <> rest = rest
    <<y::bytes-1, _::binary>> = rest
    swap_letter(state, x, y)
  end
  def dothing("rotate left " <> rest, state) do
    {x, _} = Integer.parse rest
    rotate_left(state, x)
  end
  def dothing("rotate right " <> rest, state) do
    {x, _} = Integer.parse rest
    IO.inspect x
    rotate_right(state, x)
  end
  def dothing("rotate based on position of letter " <> rest, state) do
    <<x, ?\n>> = rest
    rotate_by_x(state, x)
  end
  def dothing("reverse positions " <> rest, state) do
    {x, " through " <> rest} = Integer.parse rest
    {y, _} = Integer.parse rest
    reverse_x_y(state, x, y)
  end
  def dothing("move position " <> rest, state) do
    {x, " to position " <> rest} = Integer.parse rest
    {y, _} = Integer.parse rest
    move_x_y(state, x, y)
  end

  # part2
  def part2("swap position " <> rest, state) do
    {x, " with position " <> rest} = Integer.parse rest
    {y, _} = Integer.parse rest
    swap_pos(state, min(x, y), max(x, y))
  end
  def part2("swap letter " <> rest, state) do
    <<x::bytes-1, rest::binary>> = rest
    " with letter " <> rest = rest
    <<y::bytes-1, _::binary>> = rest
    swap_letter(state, x, y)
  end
  def part2("rotate left " <> rest, state) do
    {x, _} = Integer.parse rest
    rotate_right(state, x)
  end
  def part2("rotate right " <> rest, state) do
    {x, _} = Integer.parse rest
    IO.inspect x
    rotate_left(state, x)
  end
  def part2("reverse positions " <> rest, state) do
    {x, " through " <> rest} = Integer.parse rest
    {y, _} = Integer.parse rest
    reverse_x_y(state, x, y)
  end
  def part2("move position " <> rest, state) do
    {x, " to position " <> rest} = Integer.parse rest
    {y, _} = Integer.parse rest
    move_x_y(state, y, x)
  end
  def part2("rotate based on position of letter " <> rest, state) do
    <<x, ?\n>> = rest
    unrotate_by_x(state, x)
  end

  def swap_pos(state, x, y) do
    len = y - x - 1
    <<s::bytes-size(x), atx::bytes-1, s2::bytes-size(len), aty::bytes-1, rest::bytes>> = state
    s <> aty <> s2 <> atx <> rest
  end
  def swap_letter(state, l1, l2) do
    state
    |> String.replace(l1, "_")
    |> String.replace(l2, l1)
    |> String.replace("_", l2)
  end
  def rotate_left(state, num) do
    num = rem(num, byte_size(state))
    <<x::bytes-size(num), y::binary>> = state
    y <> x
  end
  def rotate_right(state, num) do
    len = byte_size(state) - rem(num, byte_size(state))
    <<x::bytes-size(len), y::binary>> = state
    y <> x
  end
  defp indexof(<<x, rest::binary>>, x), do: 0
  defp indexof(<<_, rest::binary>>, x), do: 1 + indexof(rest, x) 
  def rotate_by_x(state, letter) do
    i = indexof(state, letter)
    i =
      if i >= 4 do
        i + 2
      else
        i + 1
      end
    rotate_right(state, i)
  end
  def unrotate_by_x(state, letter) do
    i = indexof(state, letter)
    amt = 
      if rem(i, 2) != 0 do
        div(i ,2)
      else
        if i == 0 do
          7
        else
          3+div(i, 2)
        end
      end
    amt =
      if amt >= 4 do
        amt + 2
      else
        amt + 1
      end
    IO.inspect i
    IO.inspect amt
    rotate_left(state, amt)
  end
  def move_x_y(state, x, y) do
    :binary.at(state, x)
    len = y - x
    <<p1::bytes-size(x), atx::bytes-1, p2::binary>> = state
    <<p1::bytes-size(y), rest::binary>> = p1 <> p2
    p1 <> atx <> rest
  end
  def reverse_x_y(state, x, y) do
    len = y - x + 1
    <<p1::bytes-size(x), p2::bytes-size(len), rest::binary>> = state
    p1 <> String.reverse(p2) <> rest
  end
end
