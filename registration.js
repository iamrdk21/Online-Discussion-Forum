$(document).ready(function() {
$("#register").click(function() {
var fname = $("#fname").val();
var lname = $("#lname").val();
var email = $("#email").val();
var userid = $("#userid").val();
var pwd = $("#pwd").val();
var conpwd = $("#conpwd").val();
if (fname == '' || lname == '' || email == '' || userid == '' || pwd == '' || conpwd == '') {
alert("No field should be empty!");
} else if ((pwd.length) < 6) {
alert("Password should atleast 6 character in length");
} else if (!(pwd).match(conpwd)) {
alert("Your passwords don't match. Try again");
} else {
$.post("registration.jsp",// {
//name1: name,
//email1: email,
//password1: password
//},
function(data) {
if (data == 'You have Successfully Registered') {
$("form")[0].reset();
}
alert(data);
});
}
});
});