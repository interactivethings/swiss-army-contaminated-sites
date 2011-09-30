$ = jQuery
po = org.polymaps

radius = 5

tips = {}

features = []

# loadFeatures = (e) ->
#   console.log e.features
#   for f in e.features
#     f.element.setAttribute("r", radius)
#     if f.data.properties.data['Vorgehen_Code'] is "3"
#       $(f.element).addClass("green")
#       console.log("green")

styleFeatures = po.stylist()
  .attr("r", radius)
  .attr("class", (d) -> "vorgehen_#{d.properties.data['Vorgehen_Code']}")

styleCounties = po.stylist()
  .attr("class", "county")

loadTooltips = (e) ->
  for f in e.features
    f.element.addEventListener("mousedown", toggleTooltips(f.data), false)
    f.element.addEventListener("dblclick", cancelTooltips, false)

showTooltips = (e) ->
  for f in e.features
    tip = tips[f.data.id]
    tip.feature = f.data
    tip.location = {
      lat: f.data.geometry.coordinates[1],
      lon: f.data.geometry.coordinates[0]
    }
    updateTooltips(tip)

moveTooltips = () ->
  for tip in tips
    update(tips[tip])

cancelTooltips = (e) ->
  e.stopPropagation();
  e.preventDefault();

updateTooltips = (tip) ->
  return if !tip.visible
  p = map.locationPoint(tip.location)
  tip.anchor.style.left = p.x - radius + "px"
  tip.anchor.style.top = p.y - radius + "px"
  $(tip.anchor).tipsy("show")

toggleTooltips = (f) ->
  tip = tips[f.id]
  unless tip
    tip = {
      anchor: document.body.appendChild(document.createElement("a")),
      visible: false,
      toggle: (e) ->
        tip.visible = !tip.visible
        updateTooltips(tip)
        $(tip.anchor).tipsy(tip.visible ? "show" : "hide")
        cancelTooltips(e)
    }
    tips[f.id] = tip
    
    $(tip.anchor).css({
      position: 'absolute'
      visibility: 'hidden'
      width: radius * 2 + 'px'
      height: radius * 2 + 'px'
    })
    
    $(tip.anchor).tipsy({
      html: true,
      fallback: f.properties.data.Gemeinde,
      gravity: $.fn.tipsy.autoNS,
      trigger: "manual"
    })
  tip.toggle

map = po.map()
.container(document.getElementById("map").appendChild(po.svg("svg")))
.center({lon: 8.596677185140349, lat: 46.77841693384364})
.zoom(8)
.add(po.interact())
.on("move", moveTooltips)
.on("resize", moveTooltips)

map.add(po.image()
.url(po.url("http://{S}tile.cloudmade.com/1a1b06b230af4efdbb989ea99e9841af/998/256/{Z}/{X}/{Y}.png")
.hosts(["a.", "b.", "c.", ""])))

$ ->
  
  $.get "media/data/vbs-belastete-standorte.json", (data) ->
    # console.log data
    
    i = 0
    for row in data.rows
      features.push
        id: "p" + i++
        type: "Feature"
        geometry:
          coordinates: [row['Longitude_WGS84'], row['Latitude_WGS84']]
          type: "Point"
        properties:
          data: row
    
    # console.log features
    
    map.add po.geoJson()
      .on("load", styleFeatures)
      .on("load", loadTooltips)
      .on("show", showTooltips)
      .features(features)
    
  $.get "media/maps/schweiz_gemeinden_geojson.json", (data) ->
    # console.log data
    p = po.geoJson()
      .features(data.features)
      .on("load", styleCounties)
    map.add p
    # console.log p
    
    map.add po.compass().pan("none")
