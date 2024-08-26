defmodule Aistorybook.Repo.Migrations.AddModels do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:projects, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :name, :text, null: false
      add :style, :text

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create table(:panels, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :text, :text, null: false
      add :image_prompt, :text
      add :width, :bigint, null: false, default: 512
      add :height, :bigint, null: false, default: 512
      add :image_id, :text
      add :font, :text, null: false, default: "Ariel"
      add :font_size, :bigint, null: false, default: 30
      add :text_col, :text, null: false, default: "#ffffff"
      add :background_col, :text, null: false, default: "#000000"
      add :x, :bigint, null: false, default: 150
      add :y, :bigint, null: false, default: 150

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :page_id, :uuid
    end

    create table(:pages, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:panels) do
      modify :page_id,
             references(:pages,
               column: :id,
               name: "panels_page_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:pages) do
      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :chapter_id, :uuid
    end

    create table(:images, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :url, :text, null: false
      add :meta, :map

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :panel_id,
          references(:panels,
            column: :id,
            name: "images_panel_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create table(:chapters, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:pages) do
      modify :chapter_id,
             references(:chapters,
               column: :id,
               name: "pages_chapter_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:chapters) do
      add :name, :text, null: false
      add :style, :text

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :project_id,
          references(:projects,
            column: :id,
            name: "chapters_project_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    drop constraint(:chapters, "chapters_project_id_fkey")

    alter table(:chapters) do
      remove :project_id
      remove :updated_at
      remove :created_at
      remove :style
      remove :name
    end

    drop constraint(:pages, "pages_chapter_id_fkey")

    alter table(:pages) do
      modify :chapter_id, :uuid
    end

    drop table(:chapters)

    drop constraint(:images, "images_panel_id_fkey")

    drop table(:images)

    alter table(:pages) do
      remove :chapter_id
      remove :updated_at
      remove :created_at
    end

    drop constraint(:panels, "panels_page_id_fkey")

    alter table(:panels) do
      modify :page_id, :uuid
    end

    drop table(:pages)

    drop table(:panels)

    drop table(:projects)
  end
end
