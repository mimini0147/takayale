$(window).load ->
    $(".flexslider").flexslider
      animationSpeed: 1000
      keyboard: true
      controlNav: true
      directionNav: true

init =
  initMap: ->
    if document.getElementById("map")
      map = new GMaps({
        div: '#map'
        lat: 48.63737 
        lng: 2.33296
      })
      map.addMarker
        lat: 48.63737 
        lng: 2.33296
        title: "Takayale"
        details:
          database_id: 42
          author: "HPNeo"

        click: (e) ->
          console.log e  if console.log
          alert "You clicked in this marker"
    else
      return
  initSize: -> 
    Response.action ->
      R = window.Response
      width = R.viewportW()
      height = R.viewportH()
      ratioWidth = (height / 10) * 16
      ratioHeight = (width / 16) * 10
      containerWidth = $('.slide_active').width()
      mobileWidth = $('#scroller ul.row').width()

      if (width < 852)
        $('#scroller ul.row li').css
          "width": mobileWidth

      $('body').css
        "width": width
        "height": height

      $('.slides').css
        "width": containerWidth
        "height": height

      $(".slides li img").css
        "height": height
        "width": ratioWidth
        "max-width": ratioWidth

init.initSize()
init.initMap()

((window, document, $, R) ->
  jQuery.fn.idle = (time) ->
    i = $(this)
    i.queue ->
      setTimeout (->
        i.dequeue()
      ), time

  current_page = $(".slide_active").children().attr("id")
  $("#main-nav a[href*="+current_page+"]").parent().addClass("active")

  $("header a").live("click", ->
    $(this).parent().parent().find($("dd")).removeClass("active")
    $(this).parent().addClass("active")
    false
  ).pjax
    container: "#slide_temp"
    duration: 3000

  $("#slide_temp").bind 'pjax:start', ->
    if $('#main-content .slide_active .wrapper').children().size() > 1
      $('#main-content .slide_active .wrapper > div').last().hide()
    $('#slides_container').append('<div class="slide slide_next"></div>')
    false

  $("#slide_temp").bind 'pjax:end', ->
    a = $('#slide_temp').html()
    $('.slide_next').html a
    $(".flexslider").flexslider
      animationSpeed: 1000
      keyboard: true
      controlNav: true
      directionNav: true
    init.initSize()
    $('.slide_next').dequeue().css(x: "100%").transition
      x: 0
      duration: 1000
      rotate: 0
      scale: 1
      easing: "in-out"
    $('.slide_active').dequeue().css(x: "0").transition
      x: '-100%'
      duration: 1000
      rotate: 0
      scale: 1
      easing: "in-out"
    , ->
      if $('#slides_container').children().size() >= 2
        $('#slides_container div').first().remove()
        if document.getElementById("scroller")
          elem = $("#main .slide_active .wrapper")
          elem.iscroll()
        else
          return
    $('.slide_next').addClass('slide_active').removeClass('slide_next')
    $('body').toggleClass('active')
    init.initMap()
    false

  if document.getElementById("scroller")
    elem = $("#main .slide_active .wrapper")
    elem.iscroll()
  else
    false
  false
) this, @document, @jQuery, @Response