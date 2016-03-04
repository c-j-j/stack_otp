defmodule StackOtp.Server do
  use GenServer

  def start_link(stack \\ []) do
    GenServer.start_link(__MODULE__, stack, name: :stack)
  end

  def init(_) do
    current_stack = StackOtp.Stash.retrieve
    {:ok, current_stack}
  end

  def pop do
    GenServer.call(:stack, :pop)
  end

  def push(item) do
    GenServer.cast(:stack, {:push, item})
  end

  def handle_call(:pop, _from_pid, current_stack) do
    [head | rest] = current_stack
    {:reply, head, rest}
  end

  def handle_cast({:push, new_item}, current_stack) do
    if is_nil(new_item) do
      raise "Cannot add nil item"
    else
      {:noreply, [new_item | current_stack]}
    end
  end

  def terminate(reason, stack) do
    IO.puts "Stashing current stack"
    StackOtp.Stash.stash(stack)
    IO.puts "terminating because #{inspect reason} at state #{inspect stack}"
  end
end

