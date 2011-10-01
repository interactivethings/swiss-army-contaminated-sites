$ = jQuery
po = org.polymaps
radius = 5
tips = {}
maxZustand = 0

iconPaths = 
  abfall: [
    'M-3.448-15.771h0.218v0.812H3.23v-0.812h0.219c0.221,0,0.401-0.18,0.401-0.401c0-0.222-0.18-0.401-0.401-0.401H3.23h-6.459h-0.218c-0.222,0-0.401,0.179-0.401,0.401C-3.849-15.95-3.669-15.771-3.448-15.771z'
    'M3.449-7.746H3.23V-8.56h-6.459v0.813h-0.218c-0.222,0-0.401,0.18-0.401,0.4c0,0.222,0.18,0.402,0.401,0.402h0.218H3.23h0.219c0.221,0,0.401-0.181,0.401-0.402S3.67-7.746,3.449-7.746z'
    'M-3.229-9.304H3.23v-4.91h-6.459V-9.304z M-1.6-12.851c-0.14-0.141-0.14-0.368,0-0.509c0.141-0.141,0.368-0.141,0.508,0L0-12.267l1.092-1.093c0.14-0.141,0.368-0.141,0.508,0c0.141,0.141,0.141,0.369,0,0.509l-1.092,1.092l1.092,1.092c0.141,0.141,0.141,0.368,0,0.509c-0.07,0.07-0.162,0.105-0.254,0.105s-0.184-0.035-0.255-0.105L0-11.25l-1.093,1.092c-0.07,0.07-0.162,0.105-0.254,0.105c-0.092,0-0.184-0.035-0.254-0.105c-0.141-0.141-0.141-0.368,0-0.509l1.091-1.092L-1.6-12.851z'
    ]
  betrieb: [
    'M2.048-10.678v-1.138l-2.298,1.138v-1.138l-2.298,1.138v-3.551c0-0.199-0.2-0.36-0.447-0.36h-0.904c-0.247,0-0.447,0.161-0.447,0.36v7.797c0,0.199,0.2,0.36,0.447,0.36h7.798c0.248,0,0.447-0.161,0.447-0.36v-4.246v-1.138L2.048-10.678z'
    'M-2.964-15.275H1.01c0.286,0,0.518-0.231,0.518-0.518S1.297-16.31,1.01-16.31h-3.974c-0.286,0-0.518,0.231-0.518,0.518C-3.482-15.506-3.25-15.275-2.964-15.275z'
    'M-0.2-16.852h2.421c0.286,0,0.518-0.231,0.518-0.518c0-0.286-0.231-0.518-0.518-0.518H-0.2c-0.286,0-0.518,0.231-0.518,0.518C-0.718-17.083-0.486-16.852-0.2-16.852z'
    ]
  unfall: [
    'M-7.388-9.848l5.148,0.533l0.69,4.175l1.621-4.269l4.909,1.82l-2.623-2.936l5.03-1.146L2.5-13.019l1.993-3.375l-4.159,2.02l-2.637-3.259c0,0-0.614,4.967-0.697,5.092S-7.388-9.848-7.388-9.848z'
    ]
  schiessplatz: [
    'M3.507-12.145h1.084h0.381h0.379c-0.179-2.559-2.226-4.61-4.783-4.796v0.379v0.381v1.085C2.111-14.921,3.338-13.689,3.507-12.145z'
    'M-3.124-11.389h-1.088h-0.38H-4.97c0.191,2.547,2.233,4.584,4.782,4.769v-0.378V-7.38v-1.085C-1.722-8.639-2.944-9.855-3.124-11.389z'
    'M0.568-14.332v2.188h2.176C2.583-13.272,1.693-14.166,0.568-14.332z'
    'M-0.188-9.228v-2.161H-2.36C-2.189-10.273-1.305-9.393-0.188-9.228z'
    'M-2.364-12.145h2.176v-2.188C-1.314-14.166-2.204-13.272-2.364-12.145z'
    'M2.739-11.389H0.568v2.161C1.684-9.393,2.569-10.273,2.739-11.389z'
    'M-4.973-12.145h0.379h0.382h1.085c0.169-1.545,1.396-2.776,2.939-2.951v-1.085v-0.381v-0.379C-2.746-16.755-4.793-14.703-4.973-12.145z'
    'M4.589-11.389H3.502c-0.181,1.533-1.4,2.75-2.935,2.925v1.084v0.382v0.379c2.548-0.186,4.59-2.223,4.781-4.77H4.97H4.589L4.589-11.389z'
    ]

# Polymaps Stylist Event Handlers

styleFeatures = po.stylist()
  .attr("r", radius)
  .attr("class", (d) -> "vorgehen_#{d.properties.data['Vorgehen_Code']}")

styleCounties = po.stylist()
  .attr("class", "county")
  .style("fill", (d) ->
    step = maxZustand/6
    z = d.properties.Zustand || 0
    
    if z == 0 then return "none"
    if z < step then return "rgba(255, 255, 178, 1)"
    if z < 2*step then return "rgba(254, 217, 118, 1)"
    if z < 3*step then return "rgba(254, 178, 76, 1)"
    if z < 4*step then return "rgba(253, 141, 60, 1)"
    if z < 5*step then return "rgba(240, 59, 32, 1)"
    if z < 6*step then return "rgba(189, 0, 38, 1)"
  )

loadCounties = (e) ->
  for f in e.features
    maxZustand = f.data.properties.Zustand if f.data.properties.Zustand > maxZustand
  # console.log maxZustand

loadMarkers = (e) ->
  for f in e.features
    marker = po.svg('path')
    marker.setAttribute('d',"M6.042-17.578c-3.238-3.233-8.483-3.229-11.716,0.01s-3.229,8.483,0.01,11.715L0.2,0l5.853-5.863
    	C9.285-9.102,9.281-14.347,6.042-17.578z")
    marker.setAttribute('class', 'markerBackground')
    icon = po.svg('g')
    icon.setAttribute('class', 'icon')
    
    switch f.data.properties.data['Typ_Code']
      when 1 # Abfall
        for d in iconPaths.abfall
          p = po.svg('path')
          p.setAttribute('d', d)
          icon.appendChild(p)
      
      when 2 # Betriebsstandort
        for d in iconPaths.betrieb
          p = po.svg('path')
          p.setAttribute('d', d)
          icon.appendChild(p)
      when 3 # Unfallstandort
        for d in iconPaths.unfall
          p = po.svg('path')
          p.setAttribute('d', d)
          icon.appendChild(p)
      when 4 # Schiessplatz
        for d in iconPaths.schiessplatz
          p = po.svg('path')
          p.setAttribute('d', d)
          icon.appendChild(p)
    
    
    d = f.data
    c = f.element
    p = c.parentNode
    u = f.element = marker
    f.icon = icon
    u.setAttribute("transform", c.getAttribute("transform"))
    icon.setAttribute("transform", c.getAttribute("transform"))
    p.removeChild(c)
    p.appendChild(u)
    p.appendChild(icon)
    
    

# Tooltip Event Handlers

loadTooltips = (e) ->
  for f in e.features
    f.element.addEventListener("mousedown", toggleTooltip(f.data), false)
    f.icon.addEventListener("mousedown", toggleTooltip(f.data), false)
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
  tip.anchor.style.top = p.y - 20 + "px"
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
  map_height = $(window).height() - map_offset.top
  console.log(map_offset.top);
  $("#map").css({
    height: map_height
    overflow: "hidden"
  })
  $("body").css({
    height: map_height
    overflow: "hidden"
  })
  
  # Load county shapes, then add them to the map
  $.get "media/maps/schweiz_gemeinden_geojson_bereinigt.json", (countyData) ->
    
    map.add po.geoJson()
      .features(countyData.features)
      .on("show", styleCounties)
      .on("load", loadCounties)
      
    # console.log p
    
    # Load points, then add them to the map
    $.get "media/data/vbs-belastete-standorte_bereinigt.json", (locationData) ->
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
        .on("load", loadMarkers)
        .on("load", loadTooltips)
        .on("show", styleFeatures)
        .on("show", showTooltips)
        .features(features)
        
      map.add po.compass()
      .pan("none")
      
      $('#locations').fadeToggle();
  
  
  # Set up view change event handlers
  
  $('#show_locations').click(showLocations)
  $('#show_counties').click(showCounties)
