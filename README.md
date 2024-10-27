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