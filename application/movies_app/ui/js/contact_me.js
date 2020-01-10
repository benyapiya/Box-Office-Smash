$(function() {

  $("#contactForm input,#contactForm select").jqBootstrapValidation({
    preventSubmit: true,
    submitError: function($form, event, errors) {
      // additional error messages or events
    },
    submitSuccess: function($form, event) {
      event.preventDefault(); // prevent default submit behaviour
      // get values from FORM
      var production_budget = $("select#production_budget").val();
      var runtimemins = $("select#runtimemins").val();
      var release_year = $("select#release_year").val();
      var release_week = $("select#release_week").val();
      var rating = $("select#rating").val();
      var genre_1 = $("select#genre_1").val();
      var genre_2 = $("select#genre_2").val();
      var genre_3 = $("select#genre_3").val();
      var genre_4 = $("select#genre_4").val();
      var actor_1 = $("select#actor_1").val();
      var actor_2 = $("select#actor_2").val();
      var actor_3 = $("select#actor_3").val();
      var actor_4 = $("select#actor_4").val();
      var studio = $("select#studio").val();
      var director = $("select#director").val();

      $this = $("#sendMessageButton");
      $this.prop("disabled", true); // Disable submit button until AJAX call is complete to prevent duplicate messages
      $.ajax({
        url: "http://ec2-34-238-50-190.compute-1.amazonaws.com:5000/exec_ml",
        type: "GET",
        headers: {
          'Access-Control-Allow-Origin': '*'
        },
        data: {
          production_budget: production_budget,
          runtimemins: runtimemins,
          release_year: release_year,
          release_week: release_week,
          rating: rating,
          genre_1: genre_1,
          genre_2: genre_2,
          genre_3: genre_3,
          genre_4: genre_4,
          actor_1: actor_1,
          actor_2: actor_2,
          actor_3: actor_3,
          actor_4: actor_4,
          studio: studio,
          director: director,
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
