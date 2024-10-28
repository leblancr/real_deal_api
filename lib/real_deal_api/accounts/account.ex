defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    has_one :user, RealDealApi.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc """
  Validate and/or cast to expected types before persisting to database.
  [:email, :hash_password]: This is a list of fields that you want
  to allow to be cast from the attrs map into the account struct.
  It attempts to convert the values from the attrs map into the types expected by the account struct.

  Fields allowed for casting:
  - `:email`
  - `:hash_password`
  """
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/ ^[^\s]+@[^\s]+$ /, message: "need @ and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end
end
