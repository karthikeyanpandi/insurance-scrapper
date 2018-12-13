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
	        maxlength: 100
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
     	}
    }
	});setTimeout(function(){
        hideLoader();
    },2500);

    $("#searchclaim").submit(function(event){
        if($("#searchclaim").valid()){
            event.preventDefault(); //prevent default action
            showLoader();
        }
    });

    $("#upload_form").submit(function(event){
        showLoader();
    });

} );