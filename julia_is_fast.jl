using Dash
using Sockets
using DataFrames
using Libdl
using BenchmarkTools

port = 8088

#
# C Sum
#

const C_code = """
#include <stddef.h>
double c_sum(size_t n, double *X) {
    double s = 0.0;
    for (size_t i = 0; i < n; ++i) {
        s += X[i];
    }
    return s;
}
"""
const Clib = tempname()   # make a temporary file
# compile to a shared library by piping C_code to gcc
# (works only if you have gcc installed):
open(`gcc -fPIC -O3 -march=native -xc -shared -o $(Clib * "." * Libdl.dlext) -`, "w") do f
    print(f, C_code) 
end

# define a Julia function that calls the C function:
c_sum(X::Array{Float64}) = ccall(("c_sum", Clib), Float64, (Csize_t, Ptr{Float64}), length(X), X)

#
# Dashboard
#

app = dash(requests_pathname_prefix="/proxy/$port/")

app.layout = html_div() do
    html_h1("Summation Benchmark"),
    html_div("Click the button to run a summation benchmark:"),
    html_button("Run Benchmark", id="button"),
    html_div(id="output")
end

function update_output(n_clicks)
    if isnothing(n_clicks)
        return ""
    end
    
    n = 100000
    a = rand(n)
    t_julia_sum = @benchmark sum($a)

    t_c_sum = @benchmark c_sum($a)

    output = html_p("""
                Time taken for summing $n numbers in Julia: $(minimum(t_julia_sum.times)) seconds
                </br>
                Time taken for summing $n numbers in C: $(minimum(t_c_sum.times)) seconds
                """)

    return output
end


callback!(app, Output("output", "children"), [Input("button", "n_clicks")]) do n_clicks
    update_output(n_clicks)
end

run_server(app, Sockets.localhost, port)
