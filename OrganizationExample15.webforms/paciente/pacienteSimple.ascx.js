function initPaciente(paciente, pacienteid, entidades) {
    addFunctionToStart(function () {
        $("#" + paciente)._autoComplete({
            url: '../webservices/servicios.asmx/GetPacienteI',
            data: { 'e': entidades },
            idField: pacienteid
        });
    });
}