defmodule Aistorybook.Page.GenPanel do
  @openai_api_key System.get_env("OPENAI_API_KEY")
  @image_server_api_key System.get_env("USER_API_KEY")
  @image_server_url System.get_env("IMAGE_SERVER_URL")

  def test do
    panel =
      Aistorybook.Page.Resources.Panel
      |> Ash.Query.load([:images])
      |> Ash.read_one!()

    img = List.first(panel.images)

    generate_and_save_img(panel, img, fn _img, url -> IO.inspect(url, label: "url") end)
  end

  def gen_image(panel) do
    image = make_placeholder_image(panel)

    spawn(fn -> generate_and_save_img(panel, image, &Aistorybook.Image.Access.set_image_url/2) end)

    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  def generate_and_save_img(panel, img, save_fn) do
    file_name = "#{panel.id}_#{length(panel.images) + 1}.jpg"

    body = %{
      "file_name" => file_name,
      "user_id" => @image_server_api_key,
      "prompt" => panel.image_prompt,
      "api_key" => @openai_api_key
    }

    # IO.inspect(body, label: "body")

    res = Req.post!(url: @image_server_url, json: body)
    # IO.inspect(res, label: "res")

    save_fn.(
      img,
      res.body["img_url"]
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
