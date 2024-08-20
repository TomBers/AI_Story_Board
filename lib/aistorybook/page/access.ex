defmodule Aistorybook.Page.Access do
  require Ash.Query

  def get_panel_by_id(panel_id) do
    Aistorybook.Page.Resources.Panel
    |> Ash.Query.load(:images)
    |> Ash.Query.filter(id == ^panel_id)
    |> Ash.read_one!()
  end
end
