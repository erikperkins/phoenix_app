defmodule Stub.Bayberry.Service.MNIST do
  def digit(_id) do
    Process.sleep(120)

    digits()
    |> Enum.random()
  end

  def digits() do
    "priv/data/digits.json"
    |> File.read!()
    |> Jason.decode!()
  end

  def classify(_image) do
    %{new: true, classification: 0}
  end

  def threads() do
    2
  end
end
