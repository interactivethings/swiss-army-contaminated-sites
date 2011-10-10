#!/usr/bin/env python
# -*- coding: utf-8  -*-

import sys
import json
import codecs
from pprint import pprint
from cStringIO import StringIO

def load(name):
  f = codecs.open(name, "r", "utf-8")
  json_object = json.load(f)
  f.close()
  return json_object


def load_municipals(file_name):
  data = load(file_name)["features"]
  municipals = dict([(m["properties"]["GMDE"], m) for m in data])
  assert len(municipals) == len(data), "municipals don't have unique GMDE codes"
  return municipals

  
def diff_sites(site1, site2):
  string1 = siteToString(site1)
  string2 = siteToString(site2)
  for left, right in zip(string1.split("\n"), string2.split("\n")):
    if left != right:
      print left
      print right


def siteToString(site):
  stream = StringIO()
  pprint(site, stream)
  return stream.getvalue()


def load_sites(file_name):
  data = load(file_name)["rows"]
  sites = dict()
  for obj in data:
    object_id = obj["Objekt_Nr"]
    if sites.has_key(object_id):
      print "duplicate:", object_id
      diff_sites(sites[object_id], obj)
    else:
      sites[object_id] = obj

  return sites


def store_sites(sites, file_name):
  f = codecs.open(file_name, "w", "utf-8")
  data = {u"rows": sites.values()}
  json.dump(data, f, separators=(',',':'))
  f.close()


def store_municipals(municipals, file_name):
  f = codecs.open(file_name, "w", "utf-8")
  data = {"type": "FeatureCollection", "features": municipals.values()}
  json.dump(data, f, separators=(',',':'))
  f.close()


def check_consistency(municipals, sites):
  failed_code = set()
  failed_name = set()
  for _, site in sites.iteritems():
    code = site["Gemeinde_Nr_BfS"]
    if not municipals.has_key(int(code)):
      failed_code.add((code, site["Gemeinde"]))
    else:
      name1 = site["Gemeinde"]
      name2 = municipals[int(code)]["properties"]["NAME"]
      if name1 != name2:
        failed_name.add((code, name1, name2))

  for code, name1, name2 in failed_name:
    print u"site and municipal use different names for GMDE code '%s': '%s' vs. '%s'" % (code, name1, name2)

  for code, name in failed_code:
    print "no municipal with GMDE code", code, "and name", name


# severity_map = {
#   0:  0, # Nicht definiert
#   2:  5, # mit Abfällen belastet, kein dringender Untersuchungsbedarf
#   3:  2, # Untersuchungsbedarf: Voruntersuchung erforderlich
#   5:  5, # mit Abfällen belastet, kein dringender Untersuchungs- bzw. Sanierungsbedarf
#   6:  7, # Untersuchungsbedarf: Detailuntersuchung erforderlich
#   7: 10, # Umwelteinwirkungen: der Standort muss saniert werden
#   8:  5, # teilsaniert: Umwelteinwirkungen unterbunden oder reduziert
# }

def add_severity(current_state, severity):  
  # Just count the locations:
  return current_state + 1
  
  # Adjust by severity (don't forget to adjust choropleth map)
  # return current_state + severity_map[severity]

def augment_municipals(municipals, sites):
  for site in sites.values():
    gmde_code = int(site["Gemeinde_Nr_BfS"])
    status_code = int(site["Vorgehen_Code"])
    if municipals.has_key(gmde_code):
      severity = add_severity(municipals[gmde_code]["properties"].get("Zustand", 0), status_code)
      municipals[gmde_code]["properties"]["Zustand"] = severity

municipals = load_municipals("source/media/maps/schweiz_gemeinden_geojson.json")
sites = load_sites("source/media/data/vbs-belastete-standorte.json")
check_consistency(municipals, sites)
augment_municipals(municipals, sites)
store_sites(sites, "source/media/data/vbs-belastete-standorte_bereinigt.json")
store_municipals(municipals, "source/media/maps/schweiz_gemeinden_geojson_bereinigt.json")

