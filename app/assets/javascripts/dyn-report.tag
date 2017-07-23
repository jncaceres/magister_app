<dyn-report>
  <a class="btn btn-primary" each="{ elems }" onclick="{ select_tag }" elem="{ name }">{ name }</a>

  <h3>Selected: { selected }</h3>

  <script>
    this.selected = "None";
    this.elems = [{ name: "alpha" }, { name: "beta" }, { name: "gamma" }]

    this.select_tag = (event) => {
      const elem = event.target.attributes.elem.value;
      console.log("selected:", elem);
      
      this.update({ selected: elem });
    };
  </script>
</dyn-report>