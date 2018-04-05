// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function revertValue(id) {
  document.getElementById(id).value = document.getElementById(id).value.split("").reverse().join("");
}

function sendAjaxRequest(id, value) {
  var parse_result;
  $.ajax({
    type: "GET",
    url: "/welcome/ajax_method_from_js",
    dataType: 'json',
    data: { data: id, value: value },
    success: function(result) {
      //alert (result.data);
      document.getElementById(id).value = result.value;
      return false;
    },
    error: function() {
      return false
    }
  });
}
