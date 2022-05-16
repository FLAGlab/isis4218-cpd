defmodule PubSub do
  @moduledoc """
  Documentation for PubSub.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PubSub.hello()
      :world

  """
  def start do
    {:ok, counter} = GenStage.start_link(Producer, 0)
    {:ok, printer} = GenStage.start_link(Consumer, :ok)
    GenStage.sync_subscribe(printer, to: counter)
  end
end
