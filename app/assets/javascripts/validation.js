// 必須フィールドが入力されていなければ背景を赤くする
function validation(elm) {
    if(elm.val() == '') elm.css("background-color","#ffebeb");
    else                elm.css("background-color","#ffffff");
}

// 読み込み終了時に実行
$(function() {
    $('.validation').each(function(index, element) {
        validation($(element));
        $(element).on('change keyup', function() {
            validation($(element));
        });
    });
});
