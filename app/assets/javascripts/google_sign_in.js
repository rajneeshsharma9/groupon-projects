function onSignInSuccess(googleUser) {
  var profile = googleUser.getBasicProfile();
  email = profile.getEmail();
  name = profile.getName();
  $.ajax({
    url: 'google-sign-in',
    type: 'GET',
    data: { email: email, name: name, provider: 'google' },
    error: function(errors) {
      console.log(errors);
      window.reload();
    }
  });
}

function onSignFailure() {
  alert('Google sign in failed');
}

function GoogleSignIn(options) {
  this.signOutButton = options.signOutButton;
}

GoogleSignIn.prototype.signOut = function() {
  var auth2 = gapi.auth2.getAuthInstance();
  auth2.signOut().then(function () {
    console.log('User signed out.');
  });
};

GoogleSignIn.prototype.attachSignOutHandler = function() {
  this.signOutButton.on("click", this.signOut);
};

GoogleSignIn.prototype.init = function() {
  this.attachSignOutHandler();
};

$(document).ready(function() {
  var options = {
    "signOutButton" : $(".logout_button"),
  },
    googleSignIn = new GoogleSignIn(options);
  googleSignIn.init();
});
