function initPaciente(urlPrefix, autoCompleteCtrlId, pacienteCtrlId, pacienteIdCtrlId, panelCtrlId, entidades) {
    $(document).on("pagecreate", "#p", function () {
        /*function selectAC(valor, texto) {
            $('#' + pacienteIdCtrlId).val(valor);
            $('#' + pacienteCtrlId).val(texto);
            $("#" + autoCompleteCtrlId).html("");
            return false;
        }
        $('#' + pacienteCtrlId).change(function () {
            if (!$(this).val()) 
                $('#' + pacienteIdCtrlId).val("");
        });*/
        $("#" + panelCtrlId).removeClass("hide");
        $("#" + autoCompleteCtrlId).on("filterablebeforefilter", function (e, data) {
            var $ul = $(this),
            $input = $(data.input),
            value = $input.val();

            $ul.html("");
            if (value && value.length > 2) {
                $('#' + pacienteIdCtrlId).val("");
                $ul.html("<li><div class='ui-loader'><span class='ui-icon ui-icon-loading'></span></div></li>");
                $ul.listview("refresh");
                $.ajax({
                    url: urlPrefix + "webservices/servicios.asmx/GetPaciente",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    type: "POST",
                    data: "{ 'q': '" + $input.val() + "', 'e': '" + entidades + "' }"
                }).then(function (response) {
                    $ul.html("");
                    $.each(response.d, function (i, val) {
                        $ul.append(
                            $("<li/>").append(
                                $("<a href='#'></a>").text(val.item).click(function () {
                                    $.goURL("pid=" + val.value);
                                    return false;
                                    // return selectAC(val.value, val.item);
                                })
                            )
                        )
                    });

                    $ul.listview("refresh")
                        .trigger("updatelayout")
                        .find(".ui-screen-hidden")
                        .removeClass("ui-screen-hidden")
                    ;
                });
            }
        });
    });
}