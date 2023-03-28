const port = 8888

 # A check to see if we are running on JuliaHub
const JULIAHUB = haskey(ENV, "JULIAHUB_USEREMAIL")

# This is a minor modification to support JuliaHub
requests_pathname_prefix = JULIAHUB ? "/proxy/$port/" : Dash.dash_env("requests_pathname_prefix")

# if we defined stylesheets, we can use them here...
external_stylesheets = @isdefined(external_stylesheets) ? external_stylesheets : String[]

# Julia follows the LISP tradition of returning the last thing
# specified in the file, so `include`ing this file will
# return a `dash(...)` call that can be assigned to `app`
dash(;requests_pathname_prefix, external_stylesheets)
