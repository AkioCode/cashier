defmodule Cashier do
  @moduledoc """
  Documentation for `Cashier`.
  """

  use Agent

  @products %{
    GR1: %{name: "Green tea", price: 311},
    SR1: %{name: "Strawberries", price: 500},
    CF1: %{name: "Coffee", price: 1123}
  }

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end
end
