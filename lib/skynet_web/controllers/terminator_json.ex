defmodule SkynetWeb.TerminatorJSON do

  @doc """
  Renders a list of terminators.
  """
  def index(%{terminators: terminators}) do
    %{data: for(terminator <- terminators, do: data(terminator))}
  end

  @doc """
  Renders a single terminator.
  """
  def show(%{terminator: terminator}) do
    %{data: data(terminator)}
  end

  def delete(_terminator) do
    %{}
  end

  defp data(terminator) do
    %{
      id: terminator.id
    }
  end
end
