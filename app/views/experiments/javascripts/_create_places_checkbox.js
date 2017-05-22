$(document).ready(function(){
  $("#experiment_room_id").change(function(){
    $(".hogehoge").remove(); //_form.html.erbにもhogehogeいるので注意
    place_table[$(this).val()].forEach( //$(this).val() = experiment_room_id?
      function (p){
        //本当は"value=" + p['id'] + "" とかしないといけないし、labelのタグにfor="[inputのid]"とかしないといけない
        $('<li class ="hogehoge"><label><input id = "" type="checkbox" value="1" />'+ p['detail'] + '</label></li>').appendTo('#place_checkbox');
      } );
      });
});
