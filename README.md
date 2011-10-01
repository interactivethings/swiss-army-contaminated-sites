Introduction
============
Interactive Things takes part in the Make.OpenData.ch Camp on September 29th.
This is our submission.

To Do
=====
tooltips content
tooltips position
choropleth colors
dots colors
legend
toggle

Data Sources
============

1. Register of Polluted Sites of the Swiss Army
-----------------------------------------------

Data source: [VBS Datensammlung Belastete Standorte.xls](https://www.oeffentlichkeitsgesetz.ch/downloads/befreite-dokumente/5/2009_12_18_VBS_Datensammlung%20Belastete_Standorte.xls)

As a first step, the coordinates were transformed from the Swiss coordinate system ([CH1903](http://de.wikipedia.org/wiki/Schweizer_Landeskoordinaten)) to the world geodetic system ([WGS84](http://en.wikipedia.org/wiki/World_Geodetic_System)) because this is more commonly used. The transformation was done in [Google Refine 2.1](http://code.google.com/p/google-refine/) with the following Python scripts that we adapted from two [Javascript conversion scripts](http://www.swisstopo.admin.ch/internet/swisstopo/en/home/products/software/products/skripts.html) by SwissTopo.

    #
    # CH1903 to WGS84 Latitude
    #
    y = cells['XKoord']['value'];
    x = cells['YKoord']['value'];
    y_aux = (y - 600000.0)/1000000.0;
    x_aux = (x - 200000.0)/1000000.0;
    lat = 16.9023892 +  3.238272 * x_aux -  0.270978 * pow(y_aux,2) -  0.002528 * pow(x_aux,2) -  0.0447 * pow(y_aux,2) * x_aux -  0.0140   * pow(x_aux,3);
    lat = lat * 100.0/36.0;
    return lat;
    
    #
    # CH1903 to WGS84 Longitude
    #
    y = cells['XKoord']['value'];
    x = cells['YKoord']['value'];
    y_aux = (y - 600000.0)/1000000.0;
    x_aux = (x - 200000.0)/1000000.0;
    lng = 2.6779094 + 4.728982 * y_aux + 0.791484 * y_aux * x_aux + 0.1306   * y_aux * pow(x_aux,2) - 0.0436 * pow(y_aux,3);
    lng = lng * 100.0/36.0;
    return lng;

To determine whether the transformation of the coordinates was successful, we used [NAVREV](http://www.swisstopo.admin.ch/internet/swisstopo/en/home/apps/calc/navref.html).


2. County borders
-----------------

The county borders were downloaded as ESRI shapefiles from [bfs.admin.ch](http://www.bfs.admin.ch/bfs/portal/de/index/dienstleistungen/geostat/datenbeschreibung/generalisierte_gemeindegrenzen.html) and then imported into [QGis 1.7.1](http://www.qgis.org/) on Mac OS X 10.7.

Because the reference coordinate system of the county borders was in CH1903, we had to make sure to set up the QGis project in the right way. As a first step we created a new QGis project and set its reference coordinate system to WGS84, then we activated ["on the fly" CRS transformation](http://qgis.spatialthoughts.com/2010/10/load-multiple-layers-in-qgis.html) in the project settings. After these settings had been made, the CH1903 geo-referenced county borders were correctly imported and transformed into the WGS84 coordinate system.

For our visualization we needed the data as [GeoJSON](http://geojson.org/), which can theoretically be exported from QGis. However, QGis constantly crashed during the export to GeoJSON operation, so we had to export the county borders layer to ESRI and then convert them to GeoJSON using [ogr2ogr](http://www.gdal.org/ogr2ogr.html):

`ogr2ogr -f "GeoJSON" target_file.json source_file.shp`

After this, the GeoJSON was ready to be used for our visualization.

Vorgehen-Codes
==============

0: Nicht definiert
2: mit Abfällen belastet, kein dringender Untersuchungsbedarf
3: Untersuchungsbedarf: Voruntersuchung erforderlich
5: mit Abfällen belastet, kein dringender Untersuchungs- bzw. Sanierungsbedarf
6: Untersuchungsbedarf: Detailuntersuchung erforderlich
7: Umwelteinwirkungen: der Standort muss saniert werden
8: teilsaniert: Umwelteinwirkungen unterbunden oder reduziert

Changelog
=========

0.1
---
Date: 2011-05-26
Author: Benjamin

Initial release. Yay!

References
==========

* Compass:      http://compass-style.org/
* CoffeeScript: http://jashkenas.github.com/coffee-script/