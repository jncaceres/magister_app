<percentage-box>
  <div class="{ correct: (value >= 66), incorrect: (value <= 33), yellow: (value > 33 && value < 66) }" if="{ value > 0 }">{ value }%</div>
  <div style="color: #555;" if="{ value == 0 }">--</div><div>val: { value }</div>
  
  <script>
    this.value = opts.value * 100;
    this.on('mount', () => {
      const update = () => {
        this.update(value: opts.value * 100)
      }

      setTimeout(update, 1000)
    })
  </script>
</percentage-box>