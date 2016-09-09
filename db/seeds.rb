# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(first_name: 'Harold', last_name: 'Muller', email: 'hlmuller@uc.cl', role: 2, password: '123456', asistencia: false, courses: Course.all, current_course_id: 0)
User.create(first_name: 'Pablo', last_name: 'Espinosa', email: 'pespinosa@uc.cl', role: 2, password: '123456', asistencia: false, courses: Course.all, current_course_id: 0)
User.create(first_name: 'Vicente', last_name: 'Martin', email: 'vrmartin@uc.cl', role: 2, password: '123456', asistencia: false, courses: Course.all, current_course_id: 0)
User.create(first_name: 'Vicente', last_name: 'Martin', email: 'vicentemartintarud@gmail.com', role: 0, password: '123456', asistencia: false, courses: Course.where(id: 2))
User.create(first_name: 'Miguel', last_name: 'Nussbaum', email: 'mn@uc.cl', role: 0, password: '123456', asistencia: false, courses: Course.where(id: 2))
User.create(first_name: 'Catalina', last_name: 'Martin', email: 'cata_martin@gmail.com', role: 0, password: '123456', asistencia: false, courses: Course.where(id: 2))
User.create(first_name: 'Camila', last_name: 'Martin', email: 'cami_martin@gmail.com', role: 0, password: '123456', asistencia: false, courses: Course.where(id: 2))
User.create(first_name: 'Patricia', last_name: 'Garcia', email: 'pgh@gmail.com', role: 0, password: '123456', asistencia: false, courses: Course.where(id: 2))
Course.create(name: "Didáctica de las matemáticas I", description: "Curso de la facultad de educación, donde se estudian métodos y bla bla bla", users: User.where(role: 2), course_code: 000)
Course.create(name: "Didáctica de las matemáticas II", description: "Curso de la facultad de educación, es la continuación de didáctica de las matemáticas I y bla bla bla", users: User.all, course_code: 0000)
