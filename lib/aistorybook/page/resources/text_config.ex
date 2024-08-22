defmodule Aistorybook.Page.Resources.TextConfig do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Page.Domain

  actions do
    defaults [:read, :create, :update]
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

    attribute :font_col, :string do
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
      default 100
      public? true
    end

    attribute :y, :integer do
      allow_nil? false
      default 100
      public? true
    end
  end

  relationships do
    belongs_to :panle, Aistorybook.Page.Resources.Panel
  end
end
