<video-tag>
  <div id="player" ref="player"></div>

  <script>
    this.player = null;
    const onPlayerReady = (event) => {
      event.target.playVideo();
    }

    const onPlayerStateChange = (event) => {
      switch(event.data) {
        case YT.PlayerState.PAUSED:
          this.send_data("paused", this.player.getCurrentTime());
          break;
        case YT.PlayerState.PLAYING:
          this.send_data("playing", this.player.getCurrentTime());
          break;
        case YT.PlayerState.ENDED:
          this.send_data("ended", this.player.getCurrentTime());
          break;
      }
    }

    const onYouTubeIframeAPIReady = (vid) => {
      if(!vid)
        return;

      this.player = new YT.Player('player', {
        height: 390,
        width:  640,
        videoId: vid,
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange
        }
      });
    }

    this.send_data = (action, seconds) => {
      const data = { action: action, seconds: Math.floor(seconds), user_id: parseInt(opts.user_id) }

      $.ajax({
        url: location.pathname + '/interactions',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ interaction: data }),
        success: (payload) => {
          console.log(payload);
        }
      })
    };
    
    this.on('mount', () => {
      timedLoad = () => {
        onYouTubeIframeAPIReady(this.opts.url);
      }
      
      setTimeout(timedLoad, 1000);
    });
  </script>

</video-tag>