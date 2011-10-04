Introduction
============
Interactive Things takes part in the Make.OpenData.ch Camp on September 30th and October 1st 2011.
This is our submission.

Contributors
============

The Interactive Things Team
---------------------------

* Benjamin Wiederkehr (map & UI coding)
* Christian Siegrist (UI design)
* Christoph Schmid (UI & icon design)
* Peter Gassner (data analysis & wrangling, QGIS taming, GitHub pages publishing)
* Jeremy Stucki (data analysis, map & UI coding)
* Flavio Gortana (icon design)

Other Contributors
------------------

* Alexander Bernbauer (last-minute data wrangling!)
* Lorenz ? (helped with ideas, some data analysis)

To Do
=====

* Double-check county map!
* Improve tooltip behavior
* Probably optimize the code a little
* Check content of description page (dead download links etc.)
* Put Fork Me Badge on description page
* License!

Data Sources
============

Register of Polluted Sites of the Swiss Army
--------------------------------------------

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


County borders
--------------

The county borders were downloaded as ESRI shapefiles from [bfs.admin.ch](http://www.bfs.admin.ch/bfs/portal/de/index/dienstleistungen/geostat/datenbeschreibung/generalisierte_gemeindegrenzen.html) and then imported into [QGis 1.7.1](http://www.qgis.org/) on Mac OS X 10.7.

Because the reference coordinate system of the county borders was in CH1903, we had to make sure to set up the QGis project in the right way. As a first step we created a new QGis project and set its reference coordinate system to WGS84, then we activated ["on the fly" CRS transformation](http://qgis.spatialthoughts.com/2010/10/load-multiple-layers-in-qgis.html) in the project settings. After these settings had been made, the CH1903 geo-referenced county borders were correctly imported and transformed into the WGS84 coordinate system.

For our visualization we needed the data as [GeoJSON](http://geojson.org/), which can theoretically be exported from QGis. However, QGis constantly crashed during the export to GeoJSON operation, so we had to export the county borders layer to ESRI and then convert them to GeoJSON using [ogr2ogr](http://www.gdal.org/ogr2ogr.html):

`ogr2ogr -f "GeoJSON" target_file.json source_file.shp`

After this, the GeoJSON was ready to be used for our visualization.

Data processing
---------------
`source/data_processing/adjust_data.py` is a Python script that uses the data from `source/media` and checks `data/vbs-belastete-standorte.json` and `maps/schweiz_gemeinden_geojson.json` for consistency and generates `data/vbs-belastete-standorte_bereinigt.json` and `maps/schweiz_gemeinden_geojson_bereinigt.json`. In doing so the script prints information about the data:

* Duplicate sites: the difference of all sites that have the same `Objekt_Nr` is printed field by field.
* Different municipal names: sites refer to the `GMDE` field of a municipal via their `Gemeinde_Nr_BfS` field. They also mention the `properties.NAME` field name of the municipal via the `Gemeinde` field. The script prints each instance where the latter one differ. Note: the convertion process of the county borders presumably breaks the German umlaute. so we have many false positives here.
* Missing municpials: If a site mentions a `Gemeinde_Nr_BfS` for which there is no `GMDE` this is reported as a missing municipal. Indeed, these municpials are not mentioned in the original data from admin.ch

`data/vbs-belastete-standorte_bereinigt.json` is the same as `data/vbs-belastete-standorte.json` but without duplicate sites. i.e. for each set of sites with the same `Objekt_Nr` the first of them in file order is taken.

`maps/schweiz_gemeinden_geojson_bereinigt.json` is the same as `maps/schweiz_gemeinden_geojson.json` but while each municipal is augmented with a new field called `Zustand`. This field is the sum of the severities of all sites that are located there. To this end, the field `Vorgehen_Code` is mapped to the respective severity using an arbitrary but carefully chosen mapping. See the Python script for details.

References
==========

* Compass:      http://compass-style.org/
* CoffeeScript: http://jashkenas.github.com/coffee-script/

Miscellaneous
=============

Vorgehen-Codes
--------------

0: Nicht definiert  
2: mit Abfällen belastet, kein dringender Untersuchungsbedarf  
3: Untersuchungsbedarf: Voruntersuchung erforderlich  
5: mit Abfällen belastet, kein dringender Untersuchungs- bzw. Sanierungsbedarf  
6: Untersuchungsbedarf: Detailuntersuchung erforderlich  
7: Umwelteinwirkungen: der Standort muss saniert werden  
8: teilsaniert: Umwelteinwirkungen unterbunden oder reduziert
