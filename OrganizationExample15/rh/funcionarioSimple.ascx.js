function initFuncionario(funcionario, funcionarioid) {
    addFunctionToStart(function() {
        $("#" + funcionario).autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonal",
                    data: "{ 'q': '" + request.term + "'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            autoFocus: true,
            search: function() {
                $("#" + funcionarioid).val("");
            },
            select: function(event, ui) {
                $("#" + funcionarioid).val(ui.item.value);
                $("#" + funcionario).val(ui.item.label);
                return false;
            }
        }).change(function() {
            if ($(this).val().length == 0)
                $("#" + funcionarioid).val("");
        });
    });
}