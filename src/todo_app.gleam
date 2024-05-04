import app/router
import app/web
import dot_env
import dot_env/env
import gleam/erlang/process
import mist
import wisp

pub fn main() {
  wisp.configure_logger()

  dot_env.load()
  let assert Ok(_) = env.get("SECRET_KEY_BASE")

  let ctx = web.Context(static_dir: static_dir(), items: [])

  let handler = router.handle_request(_, ctx)

  let assert Ok(_) =
    wisp.mist_handler(handler, "secret_key")
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn static_dir() {
  let assert Ok(priv_dir) = wisp.priv_directory("todo_app")
  priv_dir <> "/static"
}
