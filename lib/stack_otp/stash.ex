defmodule StackOtp.Stash do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :stash)
  end

  def stash(to_stash) do
    GenServer.cast(:stash, {:stash_away, to_stash})
  end

  def retrieve do
    GenServer.call(:stash, :get)
  end

  def handle_call(:get, _from_pid, stash) do
    {:reply, stash, stash}
  end

  def handle_cast({:stash_away, to_stash}, current_stash) do
    {:noreply, to_stash}
  end
end
