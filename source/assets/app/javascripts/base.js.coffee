$ = jQuery
po = org.polymaps
radius = 5
tips = {}

# Polymaps Stylist Event Handlers

styleFeatures = po.stylist()
  .attr("r", radius)
  .attr("class", (d) -> "vorgehen_#{d.properties.data['Vorgehen_Code']}")

styleCounties = po.stylist()
  .attr("class", "county")

# Tooltip Event Handlers

loadTooltips = (e) ->
  for f in e.features
    f.element.addEventListener("mousedown", toggleTooltip(f.data), false)
    f.element.addEventListener("dblclick", cancelTooltip, false)

showTooltips = (e) ->
  for f in e.features
    tip = tips[f.data.id]
    tip.feature = f.data
    tip.location = {
      lat: f.data.geometry.coordinates[1],
      lon: f.data.geometry.coordinates[0]
    }
    updateTooltip(tip)

moveTooltips = () ->
  # console.log tips
  for id, tip of tips
    updateTooltip(tip) 

cancelTooltip = (e) ->
  e.stopPropagation()
  e.preventDefault()

updateTooltip = (tip) ->
  return unless tip.visible
  p = map.locationPoint(tip.location)
  tip.anchor.style.left = p.x - radius + "px"
  tip.anchor.style.top = p.y - radius + "px"
  $(tip.anchor).tipsy("show")

toggleTooltip = (f) ->
  tip = tips[f.id]
  unless tip
    tip = {
      anchor: document.getElementById("map").appendChild(document.createElement("a")),
      visible: false,
      toggle: (e) ->
        tip.visible = !tip.visible
        updateTooltip(tip)
        $(tip.anchor).tipsy( if tip.visible then "show" else "hide")
        cancelTooltip(e)
    }
    tips[f.id] = tip
    
    $(tip.anchor).css({
      position: 'absolute'
      visibility: 'hidden'
      width: radius * 2 + 'px'
      height: radius * 2 + 'px'
    })
    
    tipContent = 
      "<h3>" + 
      f.properties.data["Typ_Text"] + 
      ": " + 
      f.properties.data["Bezeichnung"] + 
      "</h3><p>" + 
      f.properties.data["Tätigkeit_Text"] +
      "<br/>" +
      f.properties.data["Gemeinde"] +
      "(" +  f.properties.data["Kanton"] + "), " +
      f.properties.data["Betriebsdauer"] +
      "<br/>" +
      f.properties.data["Vorgehen_Text"] +
      "</p>"
      
    
    $(tip.anchor).tipsy({
      # fade: true,
      fallback: tipContent,
      gravity: $.fn.tipsy.autoNS,
      trigger: "manual",
      html: true
    })
    
  tip.toggle

# View change

showCounties = (e) ->
  $('#show_locations').removeClass "active"
  $('#show_counties').addClass "active"
  $('#map').removeClass("show_locations").addClass("show_counties")
  e.stopPropagation()
  e.preventDefault()
  toggleLegends()
  
showLocations = (e) ->
  $('#show_counties').removeClass "active"
  $('#show_locations').addClass "active"
  $('#map').removeClass("show_counties").addClass("show_locations")
  e.stopPropagation()
  e.preventDefault()
  toggleLegends()
  
  
toggleLegends = (e) ->
  $('#counties').fadeToggle();
  $('#locations').fadeToggle();

# Setup map
map = po.map()
.container(document.getElementById("map").appendChild(po.svg("svg")))
.center({lon: 8.596677185140349, lat: 46.77841693384364})
.zoom(8)
.zoomRange([6,18])
.add(po.interact())
.on("move", moveTooltips)
.on("resize", moveTooltips)

# Add map background tiles
map.add(po.image()
.url(po.url("http://{S}tile.cloudmade.com/1a1b06b230af4efdbb989ea99e9841af/45763/256/{Z}/{X}/{Y}.png")
.hosts(["a.", "b.", "c.", ""])))

# DOM Loaded:
$ ->
  map_offset = $("#map").offset()
  $("#map").css({
    #height: $(document).height() - map_offset.top
  })
  
  # Load county shapes, then add them to the map
  $.get "media/maps/schweiz_gemeinden_geojson.json", (countyData) ->
    
    map.add po.geoJson()
      .features(countyData.features)
      .on("load", styleCounties)
    # console.log p
    
    # Load points, then add them to the map
    $.get "media/data/vbs-belastete-standorte.json", (locationData) ->
      # console.log data
    
      i = 0
      features = []
      for row in locationData.rows
        features.push
          id: "p" + i++
          type: "Feature"
          geometry:
            coordinates: [row['Longitude_WGS84'], row['Latitude_WGS84']]
            type: "Point"
          properties:
            data: row
            
      map.add po.geoJson()
        .on("load", styleFeatures)
        .on("load", loadTooltips)
        .on("show", showTooltips)
        .features(features)
        
      map.add po.compass().pan("none")
      $('#locations').fadeToggle();
  
  
  # Set up view change event handlers
  
  $('#show_locations').click(showLocations)
  $('#show_counties').click(showCounties)
