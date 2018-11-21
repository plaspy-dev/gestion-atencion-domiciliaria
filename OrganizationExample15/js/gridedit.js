var regexURL = /^(.*)(\/)(.*)?$/;

function editRow(id) {
    $.ajax({
        url: url.replace(regexURL, "$1/_$3"),
        data: { id: id },
        success: function (data) {
            $("#PP").remove();
            $("body").append($(data));
            $("#PP").modal().ajaxForm();
            $.validator.unobtrusive.parse(document);
            $.setDocumentProperties(docPath, id);
        }
    });
    return false;
}
function deleteRow(id) {
    if (confirm("¿Está seguro de eliminar este elemento?")) {
        $.ajax({
            url: url.replace(regexURL, "$1/___$3"),
            data: { id: id },
            method: "POST",
            success: function (data) {
                eval(data);
            }
        });
    }
    return false;
}

function startGrid() {
    var $gpe = $("#gpe");
    if ($gpe[0].__gridStarted) {
        $gpe.bootgrid("destroy");
        $gpe[0].__gridStarted = null;
        setTimeout(startGrid);
        return;
    }
    $gpe[0].__gridStarted = true;
    var localstoragename = "gderc";
    var rowCount = [10, 25, 50, -1];
    if (localStorage[localstoragename] && localStorage[localstoragename] != rowCount[0])
        rowCount.splice(0, 0, localStorage[localstoragename]);

    var printurl = url.replace(regexURL, "$1/_$3");
    var gridEditFormatters = window.gridEditFormatters || {};
    var formatters = $.extend(gridEditFormatters, {
        select: function (column, row) {
            return '<a href="#" onclick="return editRow(\'' + row[column.id] + '\');" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></a>';
        }
        , delete: function (column, row) {
            return '<a href="#" onclick="return deleteRow(\'' + row[column.id] + '\');" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i></a>';
        },
        print: function (column, row) {
            return '<a href="' + printurl + '?id=' + row[column.id] + '&pd=1" target="_blank" class="btn btn-default btn-xs"><i class="fa fa-print"></i></a>';
        },
        pdf: function (column, row) {
            return '<a href="' + printurl + '?id=' + row[column.id] + '&pdf=1" class="btn btn-default btn-xs"><i class="fa fa-file-pdf-o"></i></a>';
        },
        currency: function (column, row) {
            if (row[column.id])
                return (+row[column.id]).formatCurrency();
            return row[column.id];
        }, check: function (column, row) {
            var check = (row[column.id] == "True" || row[column.id] == "true" || row[column.id] == "1")
            return '<input type="checkbox" class="pull-right" disabled="disabled" ' + (check ? 'checked="checked"' : "") + '/>';
        }
    });
    $gpe.bootgrid({
        ajax: true,
        rowCount: rowCount,
        labels: $.gridLabels,
        url: url.replace(regexURL, "$1/__$3"),
        statusMapping: {
            4: "expired"
        },
        maxSpan: {
            days: 31
        },
        post: function () {
            return $('#fquery').find("form").serializeArray().reduce(function (obj, item) {
                if (obj[item.name]) {
                    if (Array.isArray(obj[item.name])) {
                        obj[item.name].push(item.value);
                    } else {
                        var tmp = obj[item.name];
                        obj[item.name] = [];
                        obj[item.name].push(tmp);
                        obj[item.name].push(item.value);
                    }
                } else obj[item.name] = item.value;
                return obj;
            }, {});
        },
        formatters: formatters
    }).on("loaded.rs.jquery.bootgrid", function () {
        localStorage[localstoragename] = $(this).bootgrid('getRowCount');
        $(this).next("#" + $(this).attr("id") + "-footer").toggle($(this).bootgrid("getTotalPageCount") > 1);
        $(".saveExcel,.printDocument,.pdfDocument").toggle($(this).bootgrid("getTotalRowCount") > 0);
        $(window).resize();
    });
}

$(function () {
    startGrid();
});