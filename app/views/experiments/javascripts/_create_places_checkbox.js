$(document).ready(function(){
  $("#experiment_room_id").change(function(){
    $(".hogehoge").remove();
    place_table[$(this).val()].forEach(
      function (p,index){
        var id_prefix = "experiment_ex_places_attributes_"+index.toString();
        var name_prefix = "experiment[ex_places_attributes][" + index.toString() + "]";
        $('<li class ="hogehoge"><label>'
        + '<input type="hidden" id="' + id_prefix + '_id" name="' + name_prefix + '[id]"/>'
        + '<input id = "' + id_prefix + '_place_id' + '" type="checkbox" value="'+ p['id'] + '" name="' + name_prefix + '[place_id]"/>'
        + p['detail']
        + '</label></li>').appendTo('#place_checkbox');
      } );
      });
});
