$ = jQuery

#console.log "Mmmh, Coffee!" if console?

# CLIENTS
over = (e) ->
  logo_bw = $(this).find('img').attr('src')
  logo_color = logo_bw.replace('bw', 'color')
  $(this)
    .find("a.client_logo")
    .css(background: "url(#{logo_color}) no-repeat center bottom")
    .end()
    .find("span")
    .stop()
    .fadeTo(200, 0, -> $(this).hide())
out = (e) -> 
  $(this)
    .find('span')
    .stop()
    .fadeTo(200, 1, -> $(this).parent("a.client_logo").css('background-image': 'none'))

# EQUAL HEIGHTS
$.fn.equalHeights = ->
  this.each ->
    tallest = 0
    row = $(this)
    columns = row.children("div").not(".bottom_image")
    img = row.find(".bottom_image")
    #columns.css('min-height': row.css('min-height'))# if row.css('height') > portrait_height
    #img.css('min-height': 0);
    columns.each ->
      thisHeight = $(this).outerHeight()
      img.css('min-height': thisHeight) if thisHeight > img.css('min-height');

# BOTTOM IMAGE POSITION
$.fn.adjustBottomImageHeight = ->
  this.each ->
    row = $(this)
    col = row.find(".bottom_image")
    imgH = col.children('img').height()
    #console.log(img.css('float'))
    col.css('min-height', '')
    if col.css('float') != 'none'
      col.css('min-height', row.height())
      col.css('min-height', imgH) if imgH > row.height()
    else
      col.css('min-height', imgH)

# FILTER
$.fn.filterize = ->
  this.each ->
    $(this)
      .click ->
        selector = $(this).attr('data-filter')
        $('.filter a').removeClass('active')
        $('#cards').isotope(filter: selector)
        $(this).addClass('active')
        return false;

# EMAIL
$.fn.email = ->
  this.each ->
    e = emailize($(this).text())
    $(this)
      .attr('href', "mailto:#{e}")
      .text(e)
emailize = (name) ->
  dom = 'interactivethings'
  "#{name.toLowerCase()}@#{dom}.com"

# LAB DATAVIS
$.fn.loadDatavisThumbs = (count = 5) ->
  req = $.getJSON("http://datavisualization.ch/aggregator/?q=latest_posts&callback=?&count=#{count}")
  this.each ->
    item = $(this)
    req.success (data) ->
      #console.log("Yay! #{count} Datavis posts loaded (cached: #{data.cached}).") if console?
      item
        .append("<li><a href='#{post.post_url}' title='#{post.post_title}'><img src='#{post.thumb_url}' alt='#{post.post_title} Teaser' class='headline_align' /></a></li>") for post in data.posts if data.status is 'ok'
      $('#lab_datavisualization_images li a[title]').qtip(
        position:
          my: 'bottom center'
          at: 'top center'
        style:
          classes: 'ui-tooltip-tipsy'
        show:
          effect: ->
            $(this)
              .show()
              .css(opacity: 0, marginTop: -20)
              .animate(opacity: 1, marginTop: 0, 100)
      )
$ ->
  $('.team .person .row, .team #overview .row').adjustBottomImageHeight()
  $(window).resize -> $('.team .person .row, .team #overview .row').adjustBottomImageHeight()
  $('.home .showcase, .project .showcase').showcase({timerIsOn:true})
  $('.work .showcase').showcase({timerIsOn:false})
  $('.works .slide, #deck, .card, .teaser').bind('mouseover mouseout', -> $(this).toggleClass('hovered'))
  $('.client').hover(over, out)
  $('.flipbook').showcase()
  $('.teaser').fitted()
  $('.card').fitted()
  $('a.email').email()
  $('#lab_datavisualization_images').loadDatavisThumbs(4)
  $('#cards').isotope(
    itemSelector: '.card',
    layoutMode: 'cellsByRow',
    cellsByRow :
        columnWidth : 380,
        rowHeight : 352
  )
  $('.filter a').filterize()