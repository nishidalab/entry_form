$(document).ready(function(){
  $("#experiment_room_id").change(function(){
    $(".hogehoge").remove(); //_form.html.erbにもhogehogeいるので注意
    var p = place_table[$(this).val()];
    $('<label class="hogehoge"><input type="checkbox" value="1" />'+ p + '</label>').appendTo('#place_checkbox'); //本当は"value=" + p['id'] + "" とかしないといけないし、labelのタグにfor="[inputのid]"とかしないといけない
  });
});
