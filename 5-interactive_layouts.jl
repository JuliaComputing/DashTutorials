using JSON
using Dash
using DataFrames
using PlotlyJS

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]

app = dash(external_stylesheets=external_stylesheets)

styles = Dict(
    "pre" => Dict(
        "border" => "thin lightgrey solid",
        "overflowX" => "scroll"
    )
)

df = DataFrame(
    "x" => [1, 2, 1, 2],
    "y" => [1, 2, 3, 4],
    "customdata" => [1, 2, 3, 4],
    "fruit" => ["apple", "apple", "orange", "orange"]
)

fig = plot(df, x=:x, y=:y, color=:fruit, marker_size=20, custom_data=:customdata, mode="markers")

app.layout = html_div() do
    dcc_graph(
        id="basic-interactions",
        figure=fig
    ),
    html_div(className="row", children=[
        html_div([
            dcc_markdown("""
                **Hover Data**

                Mouse over values in the graph.
            """),
            html_pre(id="hover-data", style=styles["pre"])
        ], className="three columns"),

        html_div([
            dcc_markdown("""
                **Click Data**

                Click on points in the graph.
            """),
            html_pre(id="click-data", style=styles["pre"]),
        ], className="three columns"),

        html_div([
            dcc_markdown("""
                **Selection Data**

                Choose the lasso or rectangle tool in the graph's menu
                bar and then select points in the graph.

                Note that if `layout.clickmode = 'event+select'`, selection data also
                accumulates (or un-accumulates) selected data if you hold down the shift
                button while clicking.
            """),
            html_pre(id="selected-data", style=styles["pre"]),
        ], className="three columns"),

        html_div([
            dcc_markdown("""
                **Zoom and Relayout Data**

                Click and drag on the graph to zoom or click on the zoom
                buttons in the graph's menu bar.
                Clicking on legend items will also fire
                this event.
            """),
            html_pre(id="relayout-data", style=styles["pre"]),
        ], className="three columns")
    ])
end

callback!(app,
    Output("hover-data", "children"),
    Input("basic-interactions", "hoverData")) do hoverData
    return JSON.json(hoverData)
end

callback!(app,
    Output("click-data", "children"),
    Input("basic-interactions", "clickData")) do clickData
    return JSON.json(clickData)
end

callback!(app,
    Output("selected-data", "children"),
    Input("basic-interactions", "selectedData")) do selectedData
    return JSON.json(selectedData)
end

callback!(app,
    Output("relayout-data", "children"),
    Input("basic-interactions", "relayoutData")) do relayoutData
    return JSON.json(relayoutData)
end


include("server.jl")
