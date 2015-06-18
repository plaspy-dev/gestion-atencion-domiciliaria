function initPaciente(paciente, pacienteid, entidades) {
    addFunctionToStart(function() {
        $("#" + paciente).autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: '../webservices/servicios.asmx/GetPacienteI',
                    data: "{ 'q': '" + request.term + "', 'e': '" + entidades  + "' }",
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
                $("#" + pacienteid).val("");
            },
            select: function(event, ui) {
                $("#" + pacienteid).val(ui.item.value);
                $("#" + paciente).val(ui.item.label);
                return false;
            }
        }).change(function() { 
            if($(this).val().length==0)
                $("#" + pacienteid).val("");
        });
    });
}