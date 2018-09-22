function initFuncionario(funcionario, funcionarioid) {
    addFunctionToStart(function () {
        $("#" + funcionario)._autoComplete({
            url: "../webservices/servicios.asmx/GetPersonal",
            idField: funcionarioid
        });
    });
}