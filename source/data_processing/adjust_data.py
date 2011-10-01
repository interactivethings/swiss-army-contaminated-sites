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
  json.dump(data, f, indent=2)
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

municipals = load_municipals("source/media/maps/schweiz_gemeinden_geojson.json")
sites = load_sites("source/media/data/vbs-belastete-standorte.json")
check_consistency(municipals, sites)

store_sites(sites, "source/media/data/vbs-belastete-standorte_bereinigt.json")

