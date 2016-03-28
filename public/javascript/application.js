$(document).ready(function(){
  $(".clickable").click(function(){
    $.get(
      '/gif',
      function(data) {
        $("#dog_gif").attr("src", data);
      })
  });
});