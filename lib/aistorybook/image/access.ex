defmodule Aistorybook.Image.Access do
  def set_image_url(image, url) do
    image
    |> Ash.Changeset.for_update(%{url: url})
    |> Ash.update!()
  end
end
