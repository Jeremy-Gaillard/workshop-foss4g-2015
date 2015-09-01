Integrating data
================

Cropping and reprojecting
-------------------------

We are only interested with a small extent of the downloaded data. The zones of interest are in the directory 'zones'.

Moreover we want to have data in the same coordinate system (namely EPG:3946). We will use the GDAL/OGR command line tools to manipulate our data.

To get the extent we are interested in can be obtained with:

    ogrinfo -al zones.shp | grep Extent

the result is:

    Extent: (1841372.165967, 5174640.031139) - (1844890.870163, 5176327.053583)

For vector data, we use ogr2ogr to carry out both operations (cropping and reprojection):

    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 roofs.shp fpc_fond_plan_communaut_fpctoit.shp
    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 arrondissements.shp adr_voie_lieu.adrarrond.shp
    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 velov_stations.shp jcd_jcdecaux.jcdvelov.shp
    ogr2ogr -clipdst 1841372.165967 5174640.031139 1844890.870163 5176327.053583 -t_srs EPSG:3946 lands.shp natural.shp

For raster data we use gdalwarp:

    gdalwarp -of gtiff -t_srs EPSG:3946 -te 1841372.165967 5174640.031139 1844890.870163 5176327.053583 MNT2009_Altitude_10m_CC46.tif  dem.tif
    gdalwarp -of gtiff -t_srs EPSG:3946 -te 1841372.165967 5174640.031139 1844890.870163 5176327.053583 Carte_agglo_Lyon_NO2_2012.tif  N02.tif


Create and populate the database
--------------------------------

To facilitate the connection to the database, we will use a *.pgpass* file, which allows us to store username and password, so as not having to type it each time. The file must be protected.

    echo "localhost:5432:*:pggis:pggis" > ~/.pgpass
    chmod 600 ~/.pgpass

We will need postgis and postgis_sfcgal extensions in a newly created databse. We use the pggis database as a template, extensions will be installed.

    psql -h localhost -U pggis -c "CREATE DATABASE lyon WITH OWNER = pggis ENCODING = 'UTF8' TEMPLATE = pggis CONNECTION LIMIT = -1;" postgres

With that we are ready to import the cropped vector data into the database:

    shp2pgsql -W LATIN1 -I -s 3946 roofs.shp roofs | psql -h localhost -U pggis lyon
    shp2pgsql -W LATIN1 -I -s 3946 arrondissements.shp arrondissements | psql -h localhost -U pggis lyon
    shp2pgsql -W LATIN1 -I -s 3946 velov_stations.shp velov_stations | psql -h localhost -U pggis lyon
    shp2pgsql -W LATIN1 -I -s 3946 lands.shp lands | psql -h localhost -U pggis lyon

and the cropped raster data:

    raster2pgsql -t 32x32 -I -s 3946 -C dem.tif dem | psql -h localhost -U pggis lyon
    raster2pgsql -t 32x32 -I -s 3946 -C N02.tif no2 | psql -h localhost -U pggis lyon


Import of CityGML data
======================

We will be using 3D textured data in some examples of this workshop. Data are coming from the Grand Lyon open data initiative. These data have been preprocessed for the needs of this workshop.

Once the .zip archive containing CityGML data has been downloaded and decompressed, we will need to download and use a thrid-party Python script to import such data in a PostGIS database.

Import into PostGIS
------------------------------

Download the Python script:
```
wget https://raw.githubusercontent.com/Oslandia/citygml2pgsql/master/citygml2pgsql.py
```

Prepare the database:
```
psql lyon -U pggis -h localhost -c "CREATE TABLE citygml(gid SERIAL PRIMARY KEY, geom GEOMETRY('POLYHEDRALSURFACEZ', 3946))"
```

Import CityGML data into the database:
```
./citygml2pgsql.py lyon3_small_subset.xml 2 3946 geom citygml | psql -U pggis -h localhost lyon
```
