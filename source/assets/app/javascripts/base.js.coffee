$ = jQuery

# console.log "Mmmh, Coffee!" if console?
$ ->
  po = org.polymaps

  radius = 10

  map = po.map()
  .container(document.getElementById("map").appendChild(po.svg("svg")))
  .center({lon: -122.20877392578124, lat: 37.65175620758778})
  .zoom(10)
  .add(po.interact())
  .on("move", move)
  .on("resize", move)

  map.add(po.image()
  .url(po.url("http://{S}tile.cloudmade.com/1a1b06b230af4efdbb989ea99e9841af/998/256/{Z}/{X}/{Y}.png")
  .hosts(["a.", "b.", "c.", ""])))
  
  map.add(po.compass()
  .pan("none"))
  
  map.add(po.geoJson()
    .on("load", load)
    .on("show", show)
    .features([
      {
        "id": "stanford",
        "properties": {
          "html": "<img src='stanford.png' width=200 height=200>"
        },
        "geometry": {
          "coordinates": [-122.16894848632812, 37.42961865341856],
          "type": "Point"
        }
      },
      {
        "id": "berkeley",
        "properties": {
          "html": "<img src='berkeley.png' width=200 height=200>"
        },
        "geometry": {
          "coordinates": [-122.26358225200948, 37.872092652605886],
          "type": "Point"
        }
      }
    ]))

  
  

  tips = {}

  load = (e) ->
    for f in e.features
      f.element.setAttribute("r", radius)
      f.element.addEventListener("mousedown", toggle(f.data), false)
      f.element.addEventListener("dblclick", cancel, false)

  show = (e) ->
    for f in e.features
      tip = tips[f.data.id]
      tip.feature = f.data
      tip.location =
        lat: f.data.geometry.coordinates[1],
        lon: f.data.geometry.coordinates[0]
      update(tip)


  move = () -> update(tips[id]) for id in tips

  cancel = (e) ->
    e.stopPropagation()
    e.preventDefault()

  update = (tip) ->
    return if (!tip.visible) # ignore
    p = map.locationPoint(tip.location)
    tip.anchor.style.left = p.x - radius + "px"
    tip.anchor.style.top = p.y - radius + "px"
    $(tip.anchor).tipsy("show")

  toggle = (f) ->
    tip = tips[f.id]
    if (!tip)
      tip = tips[f.id] =
        anchor: document.body.appendChild(document.createElement("a")),
        visible: false,
        toggle: (e) ->
          tip.visible = !tip.visible
          update(tip)
          $(tip.anchor).tipsy(tip.visible ? "show" : "hide")
          cancel(e)
    
      tip.anchor.style.position = "absolute"
      tip.anchor.style.visibility = "hidden"
      tip.anchor.style.width = radius * 2 + "px"
      tip.anchor.style.height = radius * 2 + "px"
      $(tip.anchor).tipsy({
        html: true,
        fallback: f.properties.html,
        gravity: $.fn.tipsy.autoNS,
        trigger: "manual"
      })
    tip.toggle
