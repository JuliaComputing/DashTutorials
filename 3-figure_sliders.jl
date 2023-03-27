using Dash
using DataFrames, PlotlyJS, CSV

data_csv = download("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv")

df = CSV.File(data_csv) |> DataFrame

years = unique(df[!, :year])

app = dash()

app.layout = html_div() do
    dcc_graph(id = "graph"),
    dcc_slider(
        id = "year-slider-1",
        min = minimum(years),
        max = maximum(years),
        marks = Dict([Symbol(v) => Symbol(v) for v in years]),
        value = minimum(years),
        step = nothing,
    )
end

callback!(
    app,
    Output("graph", "figure"),
    Input("year-slider-1", "value"),
) do selected_year
    return Plot(
        df[df.year .== selected_year, :],
        Layout(
            xaxis_type = "log",
            xaxis_title = "GDP Per Capita",
            yaxis_title = "Life Expectancy",
            legend_x = 0,
            legend_y = 1,
            hovermode = "closest",
            transition_duration = 500
        ),
        x = :gdpPercap,
        y = :lifeExp,
        text = :country,
        group = :continent,
        mode = "markers",
        marker_size = 15,
        marker_line_color = "white",
    )
end

run_server(app, "0.0.0.0", debug = true)