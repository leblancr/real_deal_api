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
  In Ecto, a changeset function is used to transform and validate data before it is inserted or updated in the database.
  It takes two main arguments:
  the data structure (usually a schema struct) and a map of attributes (the new data) that you want to apply to that structure.

  The cast/3 function is used to convert the attributes from the map into the expected types defined in the schema.
  You specify which fields you want to allow for casting.

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
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "need @ and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> put_password_hash() # call below function
  end

  @doc """
  The function expects an input that matches the structure of an Ecto.Changeset struct, this is specified by the pattern
  %Ecto.Changeset{...} (the pattern goes on the left of =), changeset is the passed in input parameter.
  It will only proceed if the input is indeed an Ecto.Changeset.
  Inside the pattern, valid?: true checks that the valid? field of the changeset is true.
  When the changeset is created, the valid? field is initially set to true by default.
  The changes: %{hash_password: hash_password} extracts the hash_password value from the changes map in the changeset.
  If hash_password exists in the changes, its value will be assigned to the local variable hash_password.
  change() is from ecto, hash_password: is the key to change in changeset struct
  change the value of hash_password in changeset struct with the hashed one
  return the result of change() which is a new changeset
  """
  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset) do
    change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password)) # change to the bcrypted password
  end

  # fallthrough for invalid changesets, order is important
  defp put_password_hash(changeset), do: changeset
end
