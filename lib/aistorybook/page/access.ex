defmodule Aistorybook.Page.Access do
  require Ash.Query

  def get_panel_by_id(panel_id) do
    Aistorybook.Page.Resources.Panel
    |> Ash.Query.load(:images)
    |> Ash.Query.filter(id == ^panel_id)
    |> Ash.read_one!()
  end

  def set_panel_image(panel, img) do
    panel
    |> Ash.Changeset.for_update(:set_img_id, %{image_id: img.id})
    |> Ash.update!()
  end
end
