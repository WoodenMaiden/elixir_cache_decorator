defmodule ProgDyn.Mem do
  use Decorator.Define, [mem: 2]

  alias Agent # for caching

  @spec mem(atom() | {:global, any()} | {:via, atom(), any()}, map(), any(), any()) :: any()
  def mem(table_name, init_values, body, context) do
    quote do
      id = case Agent.start_link(fn -> Map.new(unquote(init_values)) end, [name: unquote(table_name)]) do
        {:ok, pid} -> pid
        {:error, {:already_started, pid}} -> pid
      end

      case Agent.get(id, fn state -> Map.get(state, unquote(context.args)) end) do
        nil ->
          result = unquote(body)
          Agent.update(id, fn state -> Map.put(state, unquote(context.args), result) end)
          result
        result ->
          result
      end
    end
  end
end
