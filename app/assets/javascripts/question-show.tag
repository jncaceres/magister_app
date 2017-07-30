<question-show>
  <h3 class="title">{ content.question }<small class="tag">{ skills.join() }</small></h3>

  <ol>
    <li each="{ content.choices }" class="{ correct: right }">{ text }</li>
  </ol>

  <h4>{ ct.question }</h4>

  <ul>
    <li each="{ ct.choices }" class="{ correct: right }">{ text }</li>
  </ul>

  <script>
    this.content = opts.data.content;
    this.ct      = opts.data.ct;
    this.skills  = opts.data.skills;
  </script>
</question-show>