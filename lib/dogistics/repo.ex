defmodule Dogistics.Repo do
  use Ecto.Repo,
    otp_app: :dogistics,
    adapter: Ecto.Adapters.Postgres
end
