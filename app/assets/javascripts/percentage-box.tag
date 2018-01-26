<percentage-box>
  <div class="{ correct: (value >= 66), incorrect: (value <= 33), yellow: (value > 33 && value < 66) }" if="{ value > 0 }">{ value }%</div>
  <div style="color: #555;" if="{ value == 0 }">--</div><div>val: { value }</div>
  
  <script>
    this.value = opts.value * 100;
  </script>
</percentage-box>