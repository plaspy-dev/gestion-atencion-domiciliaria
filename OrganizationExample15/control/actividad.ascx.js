function initActividad(rootdocument, actividadctrl, actividadidctrl) {

    addFunctionToStart(function () {
        $("#" + actividadctrl).autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: rootdocument + "webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': '173' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function (data) { return data; },
                    success: function (data) {
                        response($.map(data.d, function (item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function (event, ui) {
                $("#" + actividadidctrl).val(ui.item.value);
                $("#" + actividadctrl).val(ui.item.label);
                return false;
            },
            search: function (event, ui) {
                $("#" + actividadidctrl).val("");
            }
        }).change(function () { if ($(this).val() == "") $("#" + actividadidctrl).val(""); });
    });
}