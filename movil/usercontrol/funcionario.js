function initFuncionario(urlPrefix, autoCompleteCtrlId, personalCtrlId, personalIdCtrlId) {
    $(document).on("pagecreate", "#p", function () {
        function selectAC(valor, texto) {
            $('#' + personalIdCtrlId).val(valor);
            $('#' + personalCtrlId).val(texto);
            $("#" + autoCompleteCtrlId).html("");
            return false;
        }
        $('#' + personalCtrlId).change(function () {
            if (!$(this).val()) 
                $('#' + personalIdCtrlId).val("");
        });
        $("#" + autoCompleteCtrlId).on("filterablebeforefilter", function (e, data) {
            var $ul = $(this),
            $input = $(data.input),
            value = $input.val();

            $ul.html("");
            if (value && value.length > 2) {
                $('#' + personalIdCtrlId).val("");
                $ul.html("<li><div class='ui-loader'><span class='ui-icon ui-icon-loading'></span></div></li>");
                $ul.listview("refresh");
                $.ajax({
                    url: urlPrefix + "webservices/servicios.asmx/GetPersonal",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    type: "POST",
                    data: "{ 'q': '" + $input.val() + "' }"
                }).then(function (response) {
                    $ul.html("");
                    $.each(response.d, function (i, val) {
                        $ul.append(
                            $("<li/>").append(
                                $("<a href='#'></a>").text(val.item).click(function () {
                                    return selectAC(val.value, val.item);
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