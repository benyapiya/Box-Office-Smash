$(function() {

  $("#contactForm input,#contactForm textarea").jqBootstrapValidation({
    preventSubmit: true,
    submitError: function($form, event, errors) {
      // additional error messages or events
    },
    submitSuccess: function($form, event) {
      event.preventDefault(); // prevent default submit behaviour
      // get values from FORM
      var movie_name = $("input#movie_name").val();
      var movie_actor = $("input#movie_actor").val();
      var movie_desc = $("input#movie_desc").val();
      var movie_genre = $("input#movie_genre").val();
      var movie_studio = $("input#movie_studio").val();
      var firstName = name; // For Success/Failure Message
      // Check for white space in name for Success/Fail message
      //if (firstName.indexOf(' ') >= 0) {
      //  firstName = name.split(' ').slice(0, -1).join(' ');
      //}
      $this = $("#sendMessageButton");
      $this.prop("disabled", true); // Disable submit button until AJAX call is complete to prevent duplicate messages
      $.ajax({
        url: "http://ec2-34-238-50-190.compute-1.amazonaws.com:5000/exec_ml",
        type: "GET",
        headers: {
          'Access-Control-Allow-Origin': '*'
        },
        data: {
          movie_name: movie_name,
          movie_actor: movie_actor,
          movie_desc: movie_desc,
          movie_genre: movie_genre,
          movie_studio: movie_studio,
        },
        cache: false,
        success: function(data) {
          console.log(data)
          // Success message
          $('#success').html("<div class='alert alert-success'>");
          $('#success > .alert-success').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
            .append("</button>");
          $('#success > .alert-success')
            .append("<strong>Predicted Demestic Gross is: </strong>");
          $('#success > .alert-success')
            .append(data);
          $('#success > .alert-success')
            .append("</strong>");
          $('#success > .alert-success')
            .append('</div>');
          //clear all fields
          //$('#contactForm').trigger("reset");
        },
        error: function() {
          // Fail message
          $('#success').html("<div class='alert alert-danger'>");
          $('#success > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
            .append("</button>");
          $('#success > .alert-danger').append($("<strong>").text("Sorry Flask API returns error. Please try again!"));
          $('#success > .alert-danger').append('</div>');
          //clear all fields
          $('#contactForm').trigger("reset");
        },
        complete: function() {
          setTimeout(function() {
            $this.prop("disabled", false); // Re-enable submit button when AJAX call is complete
          }, 1000);
        }
      });
    },
    filter: function() {
      return $(this).is(":visible");
    },
  });

  $("a[data-toggle=\"tab\"]").click(function(e) {
    e.preventDefault();
    $(this).tab("show");
  });
});

/*When clicking on Full hide fail/success boxes */
$('#name').focus(function() {
  $('#success').html('');
});
