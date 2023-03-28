using Dash

app = include("app.jl")

app.layout = html_div() do
    html_h6("Change the value in the text box to see callbacks in action!"),
    html_div(
        children = [
            "Input: ",
            dcc_input(id = "my-input", value = "initial value", type = "text")
        ],
    ),
    html_br(),
    html_div(id = "my-output")
end

callback!(app, Output("my-output", "children"), Input("my-input", "value")) do input_value
    "Output: $(input_value)"
end

include("server.jl")