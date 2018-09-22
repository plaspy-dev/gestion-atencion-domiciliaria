function initActividad(rootdocument, actividadctrl, actividadidctrl) {
    addFunctionToStart(function () {
        $("#" + actividadctrl)._autoComplete({
            url: rootdocument + "webservices/servicios.asmx/GetMedicamentos",
            data: { t: 173 },
            idField: actividadidctrl
        });
    });
}