defmodule RealDealApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :full_name, :gender, :biography, :account_id]}  # adjust fields as necessary
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :full_name, :string
    field :gender, :string
    field :biography, :string
    belongs_to :account, RealDealApi.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :full_name, :gender, :biography])
    |> validate_required([:account_id])
  end
end
