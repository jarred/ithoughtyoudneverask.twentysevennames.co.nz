App =

  currentImage: 0
  
  init: ->
    _.bindAll @
    _.each $('.image'), @loadImage
    _.each $('.full-image'), @loadImage
    $(window).bind 'scroll', @position
    Mousetrap.bind 'left', @previousImage
    Mousetrap.bind 'right', @nextImage
    Mousetrap.bind 'up', @previousImage
    Mousetrap.bind 'down', @nextImage
    Mousetrap.bind 'j', @nextImage
    Mousetrap.bind 'k', @previousImage
    $('a.sound').bind 'click', @toggleSound
    $('a.to-credits').bind 'click', @toCredits
    console.log $.browser
    # SC.initialize
    #   client_id: "d47b942351e59deb9ec38d90a15beb81"
    # SC.whenStreamingReady @initAudio
    @initAudio()
    @initVideo()
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
    # console.log 'position'
    if $.browser.mozilla
      $el = $('html')
    else
      $el = $('body')
    scrollTop = $el.scrollTop()
    h = $('#left').height()
    y = scrollTop
    # @currentImage = Math.round((y/h)*13)
    if scrollTop >= h
      $el.scrollTop 0
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
    return if n > 13
    if $.browser.mozilla
      $el = $('html')
    else
      $el = $('body')

    $el.animate
      scrollTop: n * 1000
    , 420
    @currentImage = n

    if n == 12
      @player?.api('play')
      @audio?.pause()
      $('a.sound').addClass('off').text('sound on')
    return

  toCredits: (e) ->
    e.preventDefault()
    @showImage(13)
    return

  initVideo: ->
    iframe = $('#vimeoplayer')[0]
    @player = $f(iframe)
    # @player.addEvent 'ready', () =>
    #   return
    @player.addEvent 'play', () =>
      @player?.api('play')
      @audio?.pause()
      $('a.sound').addClass('off').text('sound on')
      return
    return

  initAudio: ->
    @audio = new buzz.sound '/audio/27names2012final1', 
      formats: ['mp3', 'ogg', 'aac']
    @audio.play()
    return

  pauseAudio: ->
    @audio.pause()
    $el = $('a.sound')
    $el.text 'sound off'
    $el.removeClass 'off'
    return

  toggleSound: (e) ->
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