# Flipped

Flipped es una plataforma de apoyo a la educación, actualmente con una versión en producción en [flipped.educacion.uc.cl].

## Requerimientos Técnicos

Esta plataforma depende de las siguientes tecnologías:

- Ruby on Rails 4.2+
- PostgreSQL 9.2+

Adicionalmente se recomienda:

- Nginx 1.12+
- Tmux 1.8+

## Actualizando versión en producción

Ya que la versión en producción sigue la rama `master` este repositorio, los pasos a seguir para hacer un nuevo deployment son:

1. Clonar este repositorio
2. Crear la modificación
3. Hacer un nuevo commit con el código
4. Pushear a este repositorio
5. Entrar vía SSH al servidor en producción
6. Ejecutar el comando `tmux a -t magister` para entrar al tmux donde corre la aplicación
7. Presionar Ctrl+C para bajar el servicio
8. Ejecutar `git pull` para actualizar el código a la última versión
9. Ejecutar `rake db:migrate` en caso de tener nuevas migraciones
10. Ejecutar `rake assets:clobber; rake assets:precompile` en caso de haber modificado los assets CSS o Javascript
11. Ejecutar `rails s` para levantar nuevamente el servidor (el entorno está preconfigurado en ambiente de producción)
