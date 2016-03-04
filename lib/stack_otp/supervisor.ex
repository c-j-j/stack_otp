defmodule StackOtp.Supervisor do
  use Supervisor

  def start_link() do
    result = {:ok, sup_pid} = Supervisor.start_link(__MODULE__, [])
    start_children(sup_pid)
    result
  end

  def start_children(sup_pid) do
    {:ok, stash_pid} = Supervisor.start_child(sup_pid, worker(StackOtp.Stash, []))
    {:ok, server_pid} = Supervisor.start_child(sup_pid, worker(StackOtp.Server, []))
  end

  def init([]) do
     supervise([], strategy: :one_for_one)
  end
end
