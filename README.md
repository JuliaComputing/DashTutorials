# Dash.jl Tutorials

This is a set of Dash.jl tutorials for use on the JuliaHub platform.

## Additions for deployment on JuliaHub IDE

The following changes are required to run a Dash.jl app from the
JuliaHub IDE:

### `dash` initialization

The following call should be changed from: 

```
app = dash()
```

to:

```
port = 8888
app = dash(requests_pathname_prefix="/proxy/$port/")
```

By default, JuliaHub IDE proxies the requests, so we need to
specify this path name to the Dash.jl so it may respond correctly.

### `run_server` address:

The following call should be changed from:

```
run_server(app, 0.0.0.0, port, debug=true)
```

to:

```
using Sockets
run_server(app, Sockets.localhost, port, debug=true)
```

This will allow the server to respond correctly.