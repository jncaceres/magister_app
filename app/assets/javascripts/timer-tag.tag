<timer-tag>
  <span>{ title }: { format(current) }</span>

  <script>
    this.title   = opts.title || 'Timer'
    this.current = opts.start || 0;

    this.format = (t) => {
      return parseInt(t/86400)+'d '+(new Date(t%86400*1000)).toUTCString().replace(/.*(\d{2}):(\d{2}):(\d{2}).*/, "$1h $2m $3s");
    }

    this.tick = () => {
      this.update({ current: ++this.current });
    };

    this.timer   = setInterval(this.tick, 1000);

    this.on('unmount', () => {
      clearInterval(this.timer);
    });
  </script>
</timer-tag>