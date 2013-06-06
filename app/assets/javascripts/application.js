// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

function counterFunction() {
    var charLeftDiv = jQuery('#characters_left');
    var textbox = jQuery('#micropost_content').val();
    var tblength = textbox.length;
    var charRemaining = 140 - tblength;
    var charLeft = (charRemaining !== 1) ? " characters left" : " character left";
    var charTooLong = (charRemaining !== -1) ? " characters too long!" : " character too long!";
    var errorClass = "error-text";
    if (charRemaining >= 0) {
        charLeftDiv.text(charRemaining + charLeft);
        charLeftDiv.removeClass(errorClass);
    } else {
        charRemaining = Math.abs(charRemaining);
        charLeftDiv.text(charRemaining + charTooLong);
        charLeftDiv.addClass(errorClass);
    }
} // http://jsfiddle.net/LpXGs/6/ -- this function is used on micropost textarea to show number of characters left