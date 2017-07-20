<dyn-report>
  <a class="btn" each="{ elems }" onclick="{ select_tag(this) }">{ this }</a>

  <h2>{ selected }</h2>

  <script>
    this.selected = "None";
    this.elems = ["alpha", "beta", "gamma"]

    this.select_tag = (elem) => {
      console.log("selected:", elem);
      
      this.update({ selected: elem });
    };
  </script>
</dyn-report>