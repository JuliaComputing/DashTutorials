const port = 8888

const JULIAHUB = haskey(ENV, "JULIAHUB_USEREMAIL") # something in ENV that is only on JuliaHub IDE

# This is a minor modification to support JuliaHub
JULIAHUB ? dash(requests_pathname_prefix="/proxy/$port/") : dash()
