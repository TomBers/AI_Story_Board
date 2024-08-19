defmodule Aistorybook.Page.Resources.Page do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Page.Domain

  actions do
    defaults [:read]

    create :create do
      accept [:text, :image_prompt, :chapter_id]
    end

    update :update do
      accept [:text, :image_prompt, :chapter_id]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :text, :string do
      allow_nil? false
      public? true
    end

    attribute :image_prompt, :string do
      allow_nil? true
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :chapter, Aistorybook.Chapter.Resources.Chapter
    has_many :images, Aistorybook.Image.Resources.Image
  end
end
