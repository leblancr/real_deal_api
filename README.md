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
mix phx.gen.json Accounts Account accounts email:string hash_password:string
Accounts = module with database interact code.
Account = schema file being created.
accounts = database table name being created.
email:string =
hash_password:string =

mix phx.gen.json Users User users account_id:references:accounts full_name:string gender:string biography:text
mix ecto.migrate

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