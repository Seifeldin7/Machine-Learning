let base64Image;
    $("#image-selector").change(function() {
        let reader = new FileReader();
        reader.onload = function(e) {
            let dataURL = reader.result;
            $('#selected-image').attr("src", dataURL);
            base64Image = dataURL.replace("data:image/jpeg;base64,","");
        }
        reader.readAsDataURL($("#image-selector")[0].files[0]);
        $("#prediction").text("");
    });
    
    $("#upload").click(function(){
        let message = {
            image: base64Image
        }
        $.post("http://127.0.0.1:5000/predict", JSON.stringify(message), function(response){
            if (response.prediction.dog){
                $("#prediction").text("This is a dog");
            }else{
                $("#prediction").text("This is a cat");
            }
        });
    }); 