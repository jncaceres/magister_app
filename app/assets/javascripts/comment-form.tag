<comment-form>
  <a href="#" if="{ !active }" onclick="{ activate }">Responder</a>
  <form onsubmit="{ send_data }" if="{ active }">
    <div class="form-group">
      <textarea ref="content" placeholder="Escribe tu comentario" rows="1" cols="40" onclick="{ expand }" onblur="{ collapse }"></textarea>
      <input type="submit" class="btn btn-primary" value="Enviar">
    </div>
  </form>
  
  <script>
    this.active = false;
    this.expand = () => {
      this.refs.content.setAttribute("rows", 5); }
    this.collapse = () => {
      if (this.refs.content.value.length < 2) this.refs.content.setAttribute("rows", 1); }
    this.activate = () => {
      this.update({ active: true }); }

    this.send_data = (event) => {
      event.preventDefault(); 
      const data = Object.assign({}, opts, { content: this.refs.content.value });

      $.ajax({
        url: '/comments',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ comment: data }),
        success: (payload) => {
          console.log(payload);
          location.reload();
        }
      })
    }
  </script>
</comment-form>