App =

  currentImage: 0
  
  init: ->
    _.bindAll @

    @iOS = false
    @iOS = true if navigator.userAgent.match(/(iPad|iPhone|iPod)/i)

    _.each $('.image'), @loadImage
    _.each $('.full-image'), @loadImage
    if @iOS
      $('body').addClass 'ios'
      @hammer = new Hammer $('body')[0], 
        drag: true
        drag_vertical: true
        drag_horizontal: false
        drag_min_distance: 0
        preventDefault: true
        transform: false
        tap: false
        tap_double: false
        hold: false
      @hammer.ondragend = (ev) =>
        @nextImage() if ev.direction == 'up'
        @previousImage() if ev.direction == 'down'
        return
      @hammer.onswipe = (ev) =>
        @nextImage() if ev.direction == 'up'
        @previousImage() if ev.direction == 'down'
        return
    else
      setInterval @position, 24
    Mousetrap.bind 'left', @previousImage
    Mousetrap.bind 'right', @nextImage
    Mousetrap.bind 'up', @previousImage
    Mousetrap.bind 'down', @nextImage
    Mousetrap.bind 'j', @nextImage
    Mousetrap.bind 'k', @previousImage
    $('a.sound').bind 'click', @toggleSound
    $('a.to-credits').bind 'click', @toCredits
    if !@iOS
      @initAudio()
      @initVideo()
    return

  loadImage: (el) ->
    $el = $(el)
    src = $el.data 'src'
    i = new Image()
    i.src = src
    $i = $(i)
    $el.append i
    return

  position: (e) ->
    if $.browser.mozilla
      $el = $('html')
    else
      $el = $('body')
    scrollTop = $el.scrollTop()
    h = $('#left').height()
    y = scrollTop
    if scrollTop >= h
      $el.scrollTop 0
    $('#right').css
      top: "#{y}px"
    return

  nextImage: () ->
    @showImage @currentImage + 1
    return false

  previousImage: () ->
    @showImage @currentImage - 1
    return false

  showImage: (n) ->
    return if n < 0
    return if n > 13
    if $.browser.mozilla
      $el = $('html')
    else
      $el = $('body')
    if @iOS
      $('#left').animate
        top: - n * 1000
      , 420
      $('#right').animate
        top: n * 1000
      , 420
    else
      $el.animate
        scrollTop: n * 1000
      , 420
    
    @currentImage = n

    if n == 12
      @player.api('play') if !@iOS
      @audio.pause() if !@iOS
      $('a.sound').addClass('off').text('sound on') if !@iOS
    return

  toCredits: (e) ->
    e.preventDefault()
    @showImage(13)
    return

  initVideo: ->
    iframe = $('#vimeoplayer')[0]
    @player = $f(iframe)
    @player.addEvent 'play', () =>
      @player.api('play')
      @audio.pause()
      $('a.sound').addClass('off').text('sound on')
      return
    return

  initAudio: ->
    @audio = new buzz.sound '/audio/27names2012final1', 
      formats: ['mp3', 'ogg', 'aac']
    @audio.play()
    return

  pauseAudio: ->
    return if @iOS
    @audio.pause()
    $el = $('a.sound')
    $el.text 'sound off'
    $el.removeClass 'off'
    return

  toggleSound: (e) ->
    return if @iOS
    e.preventDefault()
    $el = $(e.target)
    if $el.hasClass 'off'
      $el.removeClass 'off'
      @audio.play()
      $el.text 'sound off'
    else
      $el.addClass 'off'
      @audio.pause()
      $el.text 'sound on'
    return

App.init()