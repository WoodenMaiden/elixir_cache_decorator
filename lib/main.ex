defmodule ProgDyn.Main do
  use ProgDyn.Mem

  use Application

  @decorate mem(:fibonacci, %{})
  def fibonacci(num) do
    case num do
      _ when num < 2 -> num
      _ -> fibonacci(num - 1) + fibonacci(num - 2)
    end
  end

  def start(_type, _args) do
    IO.puts fibonacci(150)

    {:ok, self()}
  end
end
