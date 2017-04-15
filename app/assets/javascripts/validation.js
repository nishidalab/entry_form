// 必須フィールドが入力されていなければ背景を赤くする
function validation(element) {
    if(element.val() == '') element.css("background-color","#ffebeb");
    else                    element.css("background-color","#ffffff");
};

// button に onclick="clicked(this)" で二重クリック防止する
function clicked(element) {
    element.disabled = true;
};

function set_validation_form(){
    $('.validation').each(function(index, element) {
        validation($(element));
        $(element).on('change keyup', function() {
            validation($(element));
        });
    });
}
// 読み込み終了時に実行
$(function() {
    set_validation_form();
});
