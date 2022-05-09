use Mix.Config

config :chat, :server, port: String.to_integer(System.get_env("PORT") || "5555")
