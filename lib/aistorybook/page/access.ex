defmodule Aistorybook.Page.Access do
  require Ash.Query

  def get_page_by_id(page_id) do
    Aistorybook.Page.Resources.Page
    |> Ash.Query.load(panels: [:text_config, :images])
    |> Ash.Query.filter(id == ^page_id)
    |> Ash.read_one!()
  end

  def get_panel_by_id(panel_id) do
    Aistorybook.Page.Resources.Panel
    |> Ash.Query.load([:text_config, :images])
    |> Ash.Query.filter(id == ^panel_id)
    |> Ash.read_one!()
  end

  def cycle_image(panel, direction) do
    image = cycle_image(panel.images, panel.image_id, direction)
    set_panel_image(panel, image)
  end

  defp cycle_image(images, current_image_id, direction) when direction in [:next, :previous] do
    # Find the index of the current image
    current_index = Enum.find_index(images, fn image -> image.id == current_image_id end)

    # Calculate the new index based on the direction
    new_index =
      case direction do
        :next -> rem(current_index + 1, length(images))
        :previous -> rem(current_index - 1 + length(images), length(images))
      end

    # Return the id of the new image
    Enum.at(images, new_index)
  end

  def set_panel_image(panel, img) do
    panel
    |> Ash.Changeset.for_update(:set_img_id, %{image_id: img.id})
    |> Ash.Changeset.load([:text_config, :images])
    |> Ash.update!()
  end

  def get_text_config(mp) do
    Map.take(mp, [:font, :font_size, :text_col, :background_col, :x, :y])
  end
end
