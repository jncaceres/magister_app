<question-show>
  <h4 class="title"><strong>{ type }</strong> <span ref="question"></span> <small class="tag">{ skills.join() }</small></h4>

  <div each="{ content.choices }" class="container { correct: right }">
    <div class="col-md-6">{ text }</div>
    <div class="col-md-6">{ n }</div>
  </div>

  <h5>{ ct.question }</h5>

  <div each="{ ct.choices }" class="container { correct: right }">
    <div class="col-md-6">{ text }</div>
    <div class="col-md-6">{ n }</div>
  </div>

  <script>
    this.on('mount', () => {
      this.refs.question.innerHTML = md_converter.makeHtml(opts.data.content.question);
    });

    this.type    = opts.data.type;
    this.content = opts.data.content;
    this.ct      = opts.data.ct;
    this.skills  = opts.data.skills;
  </script>
</question-show>