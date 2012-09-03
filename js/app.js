// Generated by CoffeeScript 1.3.3
(function() {
  var App;

  App = {
    currentImage: 0,
    init: function() {
      _.bindAll(this);
      _.each($('.image'), this.loadImage);
      _.each($('.full-image'), this.loadImage);
      $(window).bind('scroll', this.position);
      Mousetrap.bind('left', this.previousImage);
      Mousetrap.bind('right', this.nextImage);
      Mousetrap.bind('up', this.previousImage);
      Mousetrap.bind('down', this.nextImage);
      Mousetrap.bind('j', this.nextImage);
      Mousetrap.bind('k', this.previousImage);
      $('a.sound').bind('click', this.toggleSound);
      $('a.to-credits').bind('click', this.toCredits);
      SC.initialize({
        client_id: "d47b942351e59deb9ec38d90a15beb81"
      });
      SC.whenStreamingReady(this.initAudio);
      this.initVideo();
    },
    loadImage: function(el) {
      var $el, $i, i, src;
      $el = $(el);
      src = $el.data('src');
      i = new Image();
      i.src = src;
      $i = $(i);
      $el.append(i);
    },
    position: function(e) {
      var h, scrollTop, y;
      scrollTop = $('body').scrollTop();
      h = $('#left').height();
      y = scrollTop;
      if (scrollTop >= h) {
        $('body').scrollTop(0);
      }
      $('#right').css({
        top: "" + y + "px"
      });
    },
    nextImage: function() {
      this.showImage(this.currentImage + 1);
      return false;
    },
    previousImage: function() {
      this.showImage(this.currentImage - 1);
      return false;
    },
    showImage: function(n) {
      var _ref, _ref1;
      console.log('showImage', n);
      if (n < 0) {
        return;
      }
      if (n > 13) {
        return;
      }
      $('body').animate({
        scrollTop: n * 1000
      }, 420);
      this.currentImage = n;
      if (n === 12) {
        if ((_ref = this.player) != null) {
          _ref.api('play');
        }
        if ((_ref1 = this.audio) != null) {
          _ref1.pause();
        }
        $('a.sound').addClass('off').text('sound on');
      }
    },
    toCredits: function(e) {
      e.preventDefault();
      this.showImage(13);
    },
    initVideo: function() {
      var iframe,
        _this = this;
      iframe = $('#vimeoplayer')[0];
      this.player = $f(iframe);
      this.player.addEvent('ready', function() {
        console.log('player ready');
      });
      this.player.addEvent('play', function() {
        var _ref, _ref1;
        console.log('player play');
        if ((_ref = _this.player) != null) {
          _ref.api('play');
        }
        if ((_ref1 = _this.audio) != null) {
          _ref1.pause();
        }
        $('a.sound').addClass('off').text('sound on');
      });
    },
    initAudio: function() {
      var _this = this;
      console.log('initAudio');
      SC.stream("/tracks/54035078", function(sound) {
        _this.audio = sound;
        return _this.audio.play();
      });
    },
    pauseAudio: function() {
      var $el;
      this.audio.pause();
      $el = $('a.sound');
      $el.text('sound off');
      $el.removeClass('off');
    },
    toggleSound: function(e) {
      var $el;
      e.preventDefault();
      $el = $(e.target);
      if ($el.hasClass('off')) {
        $el.removeClass('off');
        this.audio.play();
        $el.text('sound off');
      } else {
        $el.addClass('off');
        this.audio.pause();
        $el.text('sound on');
      }
    }
  };

  App.init();

}).call(this);
