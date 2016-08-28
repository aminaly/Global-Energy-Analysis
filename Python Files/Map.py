
import plotly.plotly as py
import pandas as pd
py.sign_in('amina.ly', '7sj2jo08xg')
file_Location = ("C:\Users\Amina\Documents\Global Energy Analysis\SIRF 2016\Country_Metadata.csv")

df = pd.read_csv(file_Location)

data = [ dict(
    type = 'choropleth',
    locations = df['Country_Code'],
    z = df['ElecConsump_kWh_perCapita_2013'],
    text = df['Country'],
    colorscale = [[0,"rgb(5, 10, 172)"],[0.35,"rgb(40, 60, 190)"],[0.5,"rgb(70, 100, 245)"],
                 [0.6,"rgb(90, 120, 245)"],[0.7,"rgb(106, 137, 247)"],[1,"rgb(220, 220, 220)"]],
            autocolorscale = False,
            reversescale = True,
            marker = dict(
                line = dict(
                    color = 'rgb(180,180,180)',
                    width = 0.5
                ) ),
            colorbar = dict(
                autotick = False,
                title = 'Electric Power<br>kWh per Capita'),
)]

layout = dict(
    title = 'Map',
    scope = 'africa',
    geo = dict(
        showframe = True,
        showcoastlines = True,
        showocean = True,
        showcountries = True,
        countrywidth = .10,
        projection = dict(
            type = 'Mercator',
            scale = 1.60,
            rotation = dict(
                lat = 0,
                lon = 80
            )
        )
    )
)

fig = dict( data=data, layout=layout )
py.plot( fig, validate=False, filename='d3-world-map' )
