# RealDealApi

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

https://www.youtube.com/watch?v=LGY_eILc8Ks
Using Phoenix Framework to Create an Elixir REST API Project

Project setup:
mix phx.new real_deal_api --no-install --app real_deal_api --database postgres --no-live --no-assets --no-html --no-dashboard --no-mailer --binary-id

$ cd real_deal_api
$ mix deps.get

Then configure your database in config/dev.exs and run:

    $ mix ecto.create

Start your Phoenix app with:

    $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phx.server

Database setup:
1. Create account table
mix phx.gen.json Accounts Account accounts email:string hash_password:string
Accounts = module with database interact code.
Account = schema file being created.
accounts = database table name being created.
email:string =
hash_password:string =

2. Create user table
mix phx.gen.json Users User users account_id:references:accounts full_name:string gender:string biography:text
mix ecto.migrate

Create first account (in elixir shell):
iex(2)> RealDealApi.Accounts.create_account(%{email: "rkba1@proton.me", hash_password: "this is hashed"})
[debug] QUERY OK source="accounts" db=21.9ms decode=1.2ms queue=0.6ms idle=1183.9ms
INSERT INTO "accounts" ("email","hash_password","inserted_at","updated_at","id") VALUES ($1,$2,$3,$4,$5) ["rkba1@proton.me", "this is hashed", ~U[2024-10-28 00:33:58Z], ~U[2024-10-28 00:33:58Z], "43d0627b-1eec-4913-bc6e-5c3a0bfecadd"]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
{:ok,
%RealDealApi.Accounts.Account{
__meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
id: "43d0627b-1eec-4913-bc6e-5c3a0bfecadd",
email: "rkba1@proton.me",
hash_password: "this is hashed",
user: #Ecto.Association.NotLoaded<association :user is not loaded>,
inserted_at: ~U[2024-10-28 00:33:58Z],
updated_at: ~U[2024-10-28 00:33:58Z]
}}


Database:
real_deal_api_dev

Flow:
1. Create account:
    RealDealApi.Accounts.create_account(%{email: "test1@proton.me", hash_password: "our_password"})
    calls RealDealApi.Accounts.Account.changeset(attrs) attrs is %{email: "test1@proton.me", hash_password: "our_password"}
    calls Ecto.Changeset.change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))
    then RealDealApi.Repo.insert()


    Example: 
    To create a new account, requires email and password:
    iex(11)> RealDealApi.Accounts.create_account(%{email: "test1@proton.me", hash_password: "our_password"})

2. Authenticate and get a json web token:
    RealDealApiWeb.Auth.Guardian.authenticate("test1@proton.me", "our_password")
    calls RealDealApi.Accounts.get_account_by_email(email) returns an account struct,
    representing an Account entity loaded from the accounts table in database as defined by 
    the RealDealApi.Accounts.Account module schema: %RealDealApi.Accounts.Account{}  
    then validate_password(password, account.hash_password)
    then create_token(account) which returns {:ok, account, token}

    Example:
    To authenticate and get a jwt, requires email and password:
    iex(12)> RealDealApiWeb.Auth.Guardian.authenticate("test1@proton.me", "our_password")

jwt:
"eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9
.eyJhdWQiOiJyZWFsX2RlYWxfYXBpIiwiZXhwIjoxNzMyODE1NjYwLCJpYXQiOjE3MzAzOTY0NjAsImlzcyI6InJlYWxfZGVhb
F9hcGkiLCJqdGkiOiI3NWJkNjRhNy1kY2IwLTRjMmMtYTIxOC0xMjQ4NTAwMjBkZDEiLCJuYmYiOjE3MzAzOTY0NTksInN1YiI
6ImQ2NzFiODA5LTBkMzYtNGI3NS04YzFlLTg1ZjE0MGVlMDA4MSIsInR5cCI6ImFjY2VzcyJ9
.6hCVBtiiUtfOYnclP19yrgSKTY1fdoxZdJrmTMKflXGMcFbjVRBfZpOQHv3TdVH3wari6rG1JhvdLqcDnHLHmQ"

Test with bad password:
iex(13)> RealDealApiWeb.Auth.Guardian.authenticate("test1@proton.me", "our_passwod")
authenticating email: test1@proton.me, password: our_passwod
[debug] QUERY OK source="accounts" db=0.2ms idle=1063.7ms
SELECT a0."id", a0."email", a0."hash_password", a0."inserted_at", a0."updated_at" FROM "accounts" AS a0 WHERE (a0."email" = $1) ["test1@proton.me"]
↳ RealDealApiWeb.Auth.Guardian.authenticate/2, at: lib/real_deal_api_web/auth/guardian.ex:36
%RealDealApi.Accounts.Account{__meta__: #Ecto.Schema.Metadata<:loaded, "accounts">, id: "d671b809-0d36-4b75-8c1e-85f140ee0081", email: "test1@proton.me", hash_password: "$2b$12$M5KcYouCJZdhKKRs5tU6.edmfrn13cXn/WA.Bw.8xUSS8AfY43Cwu", user: #Ecto.Association.NotLoaded<association :user is not loaded>, inserted_at: ~U[2024-10-31 17:37:06Z], updated_at: ~U[2024-10-31 17:37:06Z]}
{:error, :unauthorized}