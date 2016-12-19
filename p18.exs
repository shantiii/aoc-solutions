defmodule P18 do
def solve input do
  first_line =
    File.read!(input)
    |> to_charlist
    |> Enum.drop(-1)
  Stream.iterate(first_line, &next_line/1)
  |> Stream.map(&Enum.count(&1, fn x -> x == ?. end))
  |> Stream.scan(&add/2)
  |> Stream.drop(399999)
  |> Enum.take(1)
end
def add(x, y) do
  IO.inspect y
  x + y
end

    def next_line(line) do
      Enum.concat([[?.],line,[?.]])
      |> char()
    end
def char([_,_]), do: []
def char([?., ?., ?^|_]=x), do: [?^|char(tl(x))]
def char([?., ?^, ?^|_]=x), do: [?^|char(tl(x))]
def char([?^, ?., ?.|_]=x), do: [?^|char(tl(x))]
def char([?^, ?^, ?.|_]=x), do: [?^|char(tl(x))]
def char([_|rest]), do: [?.|char(rest)]
end
