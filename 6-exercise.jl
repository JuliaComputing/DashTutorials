# Run with: julia --project 6-exercise.jl

using CSV
using DataFrames


# 1: 
# Go to:
# https://people.sc.fsu.edu/~jburkardt/data/csv/csv.html
# and select a CSV data set to study

# 2:
# Use the CSV link and construct a DataFrame
# Hint:
# We need to download then read the data
# (some data sets may not look right, so try a few!)

df = nothing # fixme

# Hint: You can comment out the line below to see the DataFrame in the terminal
# @show df

using Dash

#setup our app with the common config
app = include("app.jl")

# 3:
# Lets add a summary of the results
# using the `describe`` function
description = html_div("") # FIXME

using PlotlyJS

# 4: 
# Let's use PlotlyJS to display some results

plot = dcc_graph(figure=Plot(df,
                             x = :Year, # FIXME
                             y = :Score, # FIXME
                             title = "A plot",
                             mode = "markers"))


app.layout = html_div() do
    html_h1("My Case Study"),
    html_div("A study about this data set!"),

    description,

    plot,

    # make our DataFrame a visual table
    dash_datatable(
        data = map(eachrow(df)) do r
          Dict(names(r) .=> values(r))
        end,
        columns=[Dict("name" =>c, "id" => c) for c in names(df)]
    )
end

# 5: BONUS
# See if you can set the title by calling `propertynames` on `app`


include("server.jl")