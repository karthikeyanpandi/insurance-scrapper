$(document).ready(function() {

    function showLoader(){
        $(".preloader").show();
    }
    function hideLoader(){
        $(".preloader").hide();
    }
    showLoader();
    setTimeout(function(){
        hideLoader();
    },2500);
    $('#example').DataTable();
    $("#searchclaim").validate({
     rules:{
     	membername: { 
	        minlength: 5,
	        maxlength: 100, 
     	},
     	accountno: { 
	        minlength: 5,
	        maxlength: 20, 
	        number: true
     	},
     	memberid: { 
            required: true,
	        minlength: 5,
	        maxlength: 20, 
	        number: true
     	},
    }
	});setTimeout(function(){
        hideLoader();
    },2500);

    $("#searchclaim").submit(function(event){
    event.preventDefault(); //prevent default action 
    showLoader();
    
    var post_url = $(this).attr("action"); //get form action url
    var request_method = $(this).attr("method"); //get form GET/POST method
    var form_data = $(this).serialize(); //Encode form elements for submission
    
    $.ajax({
    url : post_url,
    type: request_method,
    data : form_data
    }).done(function(response){ 
        setTimeout(function(){
            hideLoader();
        },1500);
    });
    });

} );