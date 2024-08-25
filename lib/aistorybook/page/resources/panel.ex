defmodule Aistorybook.Page.Resources.Panel do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Page.Domain

  actions do
    defaults [:read]

    create :create do
      accept [:text, :image_prompt, :width, :height, :page_id]
    end

    update :update do
      accept [:text, :image_prompt, :width, :height, :page_id]
    end

    update :update_text do
      accept [:text, :font, :font_size, :text_col, :background_col, :x, :y]
    end

    update :set_img_id do
      accept [:image_id]
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

    attribute :width, :integer do
      allow_nil? false
      default 300
      public? true
    end

    attribute :height, :integer do
      allow_nil? false
      default 200
      public? true
    end

    attribute :image_id, :string do
      allow_nil? true
      public? true
    end

    attribute :font, :string do
      allow_nil? false
      default "Ariel"
      public? true
    end

    attribute :font_size, :integer do
      allow_nil? false
      default 30
      public? true
    end

    attribute :text_col, :string do
      allow_nil? false
      default "#ffffff"
      public? true
    end

    attribute :background_col, :string do
      allow_nil? false
      default "#000000"
      public? true
    end

    attribute :x, :integer do
      allow_nil? false
      default 512
      public? true
    end

    attribute :y, :integer do
      allow_nil? false
      default 512
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :page, Aistorybook.Page.Resources.Page
    has_many :images, Aistorybook.Image.Resources.Image
  end
end
