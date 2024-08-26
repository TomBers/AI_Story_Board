defmodule Aistorybook.Page.GenPanel do
  def gen_image(panel) do
    image = make_placeholder_image(panel)

    spawn(fn -> generate_and_save_img(panel, image, &Aistorybook.Image.Access.set_image_url/3) end)

    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  def generate_and_save_img(panel, img, save_fn) do
    openai_api_key = System.fetch_env!("OPENAI_API_KEY")
    image_server_api_key = System.fetch_env!("USER_API_KEY")
    image_server_url = System.fetch_env!("IMAGE_SERVER_URL")

    file_name = "#{panel.id}_#{length(panel.images) + 1}.jpg"

    body = %{
      "file_name" => file_name,
      "user_id" => image_server_api_key,
      "prompt" => panel.image_prompt,
      "api_key" => openai_api_key
    }

    IO.inspect(body, label: "body")

    IO.inspect(image_server_url, label: "img_server")

    res = Req.post!(url: image_server_url, json: body, receive_timeout: 120_000)
    IO.inspect(res, label: "res")

    save_fn.(
      img,
      res.body["img_url"],
      panel.page_id
    )
  end

  def make_placeholder_image(panel) do
    Aistorybook.Image.Resources.Image
    |> Ash.Changeset.for_create(:create, %{
      url: "/images/placeholder.jpg",
      panel_id: panel.id,
      meta: nil
    })
    |> Ash.create!()
  end
end
