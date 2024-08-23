defmodule Aistorybook.Page.GenPanel do
  @api_url "https://api.openai.com/v1/images/generations"
  @api_key System.get_env("OPENAI_API_KEY")

  def gen_image(panel) do
    image = make_image(panel.id, img_gen_req(panel.image_prompt))
    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  def img_gen_req(prompt) do
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{@api_key}"}
    ]

    body = %{
      "model" => "dall-e-3",
      "prompt" => prompt,
      "n" => 1,
      "response_format" => "b64_json",
      "size" => "1024x1024"
    }

    response =
      Req.post!(@api_url,
        headers: headers,
        json: body
      )

    case response.status do
      200 ->
        image_data_base64 = response.body["data"] |> List.first() |> Map.get("b64_json")

        save_image(image_data_base64)

      _ ->
        IO.puts("Failed to generate image: #{response.status}")
    end

    # TODO - cyle through a few set images
    # https://picsum.photos/id/1/200/300
    {"https://picsum.photos/id/#{Enum.random(1..60)}/200/300", nil}
  end

  defp save_image(image_data_base64) do
    file_name = "generated_image.png"

    # Decode the base64 string to binary
    image_data_binary = Base.decode64!(image_data_base64)

    # Write the binary data to a file
    File.write!(file_name, image_data_binary)

    IO.puts("Image saved as #{file_name}")
  end

  defp make_image(panel_id, {url, meta}) do
    Aistorybook.Image.Resources.Image
    |> Ash.Changeset.for_create(:create, %{
      url: url,
      panel_id: panel_id,
      meta: meta
    })
    |> Ash.create!()
  end
end
