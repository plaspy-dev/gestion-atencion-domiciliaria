var elementos = null;
function mostrarAut(mostrar) {
    var temp = 0;
    elementos.each(function(i) {
        temp = i;
        if (i > 7) {
            mostrar ? $(this).show() : $(this).hide();
        } else {
            $(this).show();
        }
    });
    if (temp<10) 
        $("#tdMas").hide();
}
function showAut() {
    if ($("#tdMas").text() == "Más") {
        mostrarAut(true);
        $("#tdMas").text("Menos");
    } else {
        mostrarAut(false);
        $("#tdMas").text("Más");
    }
    $("#tdMas").parent().show();
}
function expandText(td) {

    $(td).parent().parent().find("tr td").each(function() {
        if ($(this).attr("title") && $(this).attr("title") != "") {
            var temp = $(this).html().replace("&nbsp;", "");
            $(this).html("&nbsp;" + $(this).attr("title"));
            $(this).attr("title", temp);
        }
    });
}
addFunctionToStart(function() {
    elementos = $("#tAutorizaciones tr");
    mostrarAut(false);
    var total = elementos.length;
    if (total > 7)
        $("#tdMas").parent().show();
});