// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require cocoon
//  require turbolinks
//= require axios
//= require showdown
//= require riot
//= require riot_rails

// Riot tags
//= require video-tag
//= require percentage-box
//= require dyn-report
//= require comment-form
//= require question-show
//= require timer-tag

//= require_tree .

window.md_converter = new showdown.Converter({ simplifiedAutoLink: true });

$(function() {
  $('#pictureInput_1').on('change', function(event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function(file) {
      var img = new Image();
      img.style.height = '100px';
      img.style.width = '100px';
      console.log(file);
      img.src = file.target.result;
      $('#target_1').html(img);
    }
    reader.readAsDataURL(image);
    console.log(files);
  });
});

$(function() {
  $('#pictureInput_2').on('change', function(event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function(file) {
      var img = new Image();
      img.style.height = '100px';
      img.style.width = '100px';
      console.log(file);
      img.src = file.target.result;
      $('#target_2').html(img);
    }
    reader.readAsDataURL(image);
    console.log(files);
  });
});




/*------------------------Función para susbribir el form--------------------------*/
/*setInterval(function(){
  $('form[data-remote]').submit();
  var email = $('#answer').val();
  alert(email);
  var form = $('#autosave');
  var method = form.attr('post').toLowerCase(); // "get" or "post"
  var action = form.attr('homeworks/:id/answers/:id/edit');// url to submit to
  $[method](action, form.serialize(), function(data){
    // Do something with the server response data
    // Or at least let the user know it saved
  });
},5000);*/

/*--------------------------------------------------------------------------------*/



/*var autosave = window.setInterval("autosaveForm()", 15000);

function autosaveForm() {
  $('form[data-remote]').submit();
}*/

$(document).ready(function() {
  riot.mount('*');
});