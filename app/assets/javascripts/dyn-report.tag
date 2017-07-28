<dyn-report>
  <table class="table">
    <thead>
      <th>Contenido / Habilidad</th>
      <th>Contenido</th>
      <th>Interpretar</th>
      <th>Análisis</th>
      <th>Evaluación</th>
      <th>Inferencia</th>
      <th>Explicación</th>
      <th>Autoregulación</th>
      <th>N</th>
    </thead>
    <tbody>
      <tr each="{ reports }">
        <td>--</td>
        <td>{ Math.round(content_sc) }%</td>
        <td>{ Math.round(interpretation_sc) }%</td>
        <td>{ Math.round(analysis_sc) }%</td>
        <td>{ Math.round(evaluation_sc) }%</td>
        <td>{ Math.round(inference_sc) }%</td>
        <td>{ Math.round(explanation_sc) }%</td>
        <td>{ Math.round(selfregulation_sc) }%</td>
        <td>{ total }</td>
      </tr>
    </tbody>
  </table>
  <script>
    this.reports = [];
    this.on('mount', () => {
      $.ajax({
        url: "/courses/1/reports/1.json",
        success: (payload) => {
          console.log(payload);
          this.update({ reports: [payload.data] });
        }
      });
    });
  </script>
</dyn-report>