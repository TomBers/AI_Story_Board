defmodule Aistorybook.Image.Resources.Image do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Image.Domain

  actions do
    defaults [:read]

    create :create do
      accept [:url, :meta, :panel_id]
    end

    update :update do
      accept [:url, :meta, :panel_id]
    end

    update :set_img_url do
      accept [:url]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :url, :string do
      allow_nil? false
      public? true
    end

    attribute :meta, :map do
      allow_nil? true
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :panel, Aistorybook.Page.Resources.Panel
  end
end
