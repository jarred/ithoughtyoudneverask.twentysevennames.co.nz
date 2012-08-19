App =

  currentImage: 0
  
  init: ->
    _.bindAll @
    _.each $('.image'), @loadImage
    _.each $('.full-image'), @loadImage
    # @scrollInt = setInterval @position, 44
    # console.log $('html').scrollTop()
    $(window).bind 'scroll', @position
    Mousetrap.bind 'left', @previousImage
    Mousetrap.bind 'right', @nextImage
    Mousetrap.bind 'up', @previousImage
    Mousetrap.bind 'down', @nextImage
    # $(window).bind 'keypress', @nextImage
    $('a.to-credits').bind 'click', @toCredits
    @initVideo()
    SC.whenStreamingReady @initAudio
    # @initAudio()
    return

  loadImage: (el) ->
    $el = $(el)
    src = $el.data 'src'
    i = new Image()
    i.src = src
    $i = $(i)
    # $el.css
      # 'backgroundImage': "url('#{src}')"
    $el.append i
    return

  position: (e) ->
    scrollTop = $('body').scrollTop()
    h = $('#left').height()
    y = scrollTop
    # @currentImage = Math.round((y/h)*13)
    if scrollTop >= h
      $('body').scrollTop 0
    $('#right').css
      top: "#{y}px"
    return

  nextImage: () ->
    # e?.preventDefault()
    @showImage @currentImage + 1
    return false

  previousImage: () ->
    # e?.preventDefault()
    @showImage @currentImage - 1
    return false

  showImage: (n) ->
    console.log 'showImage', n
    return if n < 0
    return if n > 12
    $('body').animate
      scrollTop: n * 1000
    , 420
    @currentImage = n
    return

  toCredits: (e) ->
    e.preventDefault()
    @showImage(12)
    return

  initVideo: ->
    iframe = $('#vimeo')[0]
    player = $f(iframe)
    player.addEvent 'ready', () =>
      console.log 'player ready'
      return
    player.addEvent 'play', () =>
      console.log 'play?'
      return
    return

  initAudio: ->
    console.log 'initAudio'
    SC.stream "/tracks/5465310", (sound) =>
      @audio = sound
      @audio.play()
    return

App.init()