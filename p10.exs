defmodule P10 do require Logger
  def solve(input) do
    File.stream!(input)
    |> Enum.to_list()
    |> Enum.reduce({%{}, %{}}, &program/2)
    |> simulate()
  end
  def program("value " <> instruction, state) do
    {value, " goes to bot " <> rest} = Integer.parse(instruction)
    {bot_id, "\n"} = Integer.parse(rest)
    add_value(state, bot_id, value)
  end
  def program("bot " <> instruction, state) do
    {giver, " gives low to " <> rest} = Integer.parse(instruction)
    {low_target, " and high to " <> rest} = parse_target(rest)
    {high_target, "\n"} = parse_target(rest)
    add_wiring(state, giver, low_target, high_target)
  end
  def parse_target("bot " <> rest) do
    {target_id, rest} = Integer.parse(rest)
    {{:bot, target_id}, rest}
  end
  def parse_target("output " <> rest) do
    {target_id, rest} = Integer.parse(rest)
    {{:output, target_id}, rest}
  end
  def add_value({bots, inputs}, bot, value) do
    new_inputs = Map.update(inputs, bot, [value], fn existing_inputs -> [value|existing_inputs] end)
    {bots, new_inputs}
  end
  def add_wiring({bots, inputs}, bot, target_low, target_high) do
    {Map.put(bots, bot, {target_low, target_high}), inputs}
  end
  def simulate({bots, input}) do
    IO.inspect input
    {first, _} = Enum.find(input, &match?({_, [_, _]}, &1))
    {bots, queue, input, output} = run(bots, [{first, bots[first]}], input, %{})
  end
  def run(bots, [], inputs, outputs) do
    Logger.info "INPUTS"
    Logger.info inspect inputs
    Logger.info "OUTPUTS"
    Logger.info inspect inputs
    {bots, [], inputs, outputs}
  end
  def run(bots, [{id, {low_target, high_target}} | rest], inputs, outputs) do
    Logger.info "Running #{id}"
    if length(inputs[id]) == 2 do
      low = Enum.min(inputs[id])
      high = Enum.max(inputs[id])
      if low == 17 and high == 61 do
        Logger.info "found it"
      end
      {new_queue, new_inputs, new_outputs} =
        {rest, inputs, outputs}
        |> update(bots, low_target, low)
        |> update(bots, high_target, high)
      run(bots, new_queue, new_inputs, new_outputs)
    else
      run(bots, rest, inputs, outputs)
    end
  end
  def update({queue, inputs, outputs}, bots, {:bot, target}, value) do
    new_queue = [{target, bots[target]} | queue]
    new_inputs = Map.update(inputs, target, [value], fn inputs -> [value | inputs] end)
    {new_queue, new_inputs, outputs}
  end
  def update({queue, inputs, outputs}, bots, {:output, bin}, value) do
    new_outputs = Map.update(outputs, bin, [value], fn inputs -> [raw: value] ++ inputs end)
    {queue, inputs, new_outputs}
  end
end
