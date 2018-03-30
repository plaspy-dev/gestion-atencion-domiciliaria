/*
controlId
queryURL
controlDataId
selectURL
autoSelect
onSelect
onClear
*/
function autoComplete(options) {
    var dataSource = new Bloodhound({
        datumTokenizer: function (d) {
            return Bloodhound.tokenizers.whitespace(d.value)
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
            url: options.queryURL + "#%QUERY",
            wildcard: '%QUERY',
            transport: function (opts, onSuccess, onError) {
                var url = opts.url.split("#")[0];
                var query = opts.url.split("#")[1];
                $.ajax({
                    url: url,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data: "{'q':'" + query + "'}",
                    type: "POST",
                    success: function (data) {
                        onSuccess($.map(data.d, function (item) {
                            return item;
                        }))
                    },
                    error: onError,
                })
            }
        }
    });

    var currentText = "";
    if (options.controlDataId) 
        currentText= $("#" + options.controlDataId).val();

    $inicio(function () {
        var $element = $('#' + options.controlId);
        var hasfocus = $element.is(":focus");
        $element.typeahead({
            hint: true,
            highlight: true,
            minLength: 3,
            autoSelect: options.autoSelect
        },
        {
            display: 'Nombre',
            source: dataSource
        }).change(function () {
            if (options.controlDataId) {
                if ($(this).val() != currentText) {
                    $("#" + options.controlDataId).val("");
                    if (options.onClear)
                        options.onClear.call(this);
                }
            }
        }).on('typeahead:select', function (e, datum) {
            currentText = datum.Nombre;
            if (options.controlDataId)
                $("#" + options.controlDataId).val(datum.Id);
            else if (options.selectURL)
                window.location = options.selectURL + datum.Id;
            if (options.onSelect)
                options.onSelect.call(this, datum.Id, datum.Nombre);
        });
        if (hasfocus)
            $element.focus();
    });
}