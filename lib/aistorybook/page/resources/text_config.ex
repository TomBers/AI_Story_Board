defmodule Aistorybook.Page.Resources.TextConfig do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Page.Domain

  actions do
    defaults [:read]

    create :create do
      accept [:panel_id]
    end

    update :update do
      accept [:font, :font_size, :text_col, :background_col, :x, :y]
    end
  end

  attributes do
    uuid_primary_key :id

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
      default "white"
      public? true
    end

    attribute :background_col, :string do
      allow_nil? false
      default "black"
      public? true
    end

    attribute :x, :integer do
      allow_nil? false
      default 200
      public? true
    end

    attribute :y, :integer do
      allow_nil? false
      default 200
      public? true
    end
  end

  relationships do
    belongs_to :panel, Aistorybook.Page.Resources.Panel
  end
end
