getSafeAngularModule()
    .controller('Gallery', function () {
        var controller = this;
        controller.galeria = {};

        function addParams(path, params) {
            if (params) {
                var index = path.indexOf("?");
                path += (index == -1 ? "?" : "&") + params;
            }
            return path;
        }

        controller.getFilePath = function (file, params) {
            if (file.startsWith("~/") || file.startsWith("/")) {
                return addParams(file.replace("~/", rootPath), params);
            }
            if (!controller.galeria.tipo) {
                controller.galeria.tipo = 0;
            }
            var path = rootPath + "Files/" + controller.galeria.tipo;
            if (controller.galeria.path) {
                path += "/" + controller.galeria.path;
            }
            return addParams(path + "/" + file, params);
        };

        controller.getFileName = function (file) {
            var lastIndex = file.lastIndexOf("/");
            if (lastIndex != -1) {
                file = file.substr(lastIndex+1);
            }
            return file.split("?")[0];
        };

        function update() {
            controller.length = 0;
            controller.json = JSON.stringify(controller.galeria);
        }

        controller.onChangeJSON = function () {
            controller.galeria = {};
            try {
                controller.galeria = JSON.parse(controller.json);
            } catch (ex) { }
            update();
        };

        controller.init = function (ctrlid) {
            controller.json = $("#" + ctrlid).val();
            controller.onChangeJSON();
        };

        controller.onDelete = function (row) {
            if (!confirm("¿Está seguro de eliminar este archivo?"))
                return;
            var index = controller.galeria.files.indexOf(row);
            if (index > -1)
                controller.galeria.files.splice(index, 1);
            if (!controller.galeria.deletedFiles)
                controller.galeria.deletedFiles = "";
            controller.galeria.deletedFiles += "," + row.split("?")[0];
            update();
        };
    });

function angulargaleriaremovefile(file) {
    var galeria = JSON.parse($("#jsongallery").val());
    galeria.files = galeria.files || [];
    var index = galeria.files.indexOf(file._fileName);
    if (index > -1)
        galeria.files.splice(index, 1);
    if (!galeria.deletedFiles)
        galeria.deletedFiles = "";
    galeria.deletedFiles += "," + file._fileName.split('?')[0];
    $("#jsongallery").val(JSON.stringify(galeria)).change();
}

function angulargaleriasuccess(file, response) {

    var galeria = JSON.parse($("#jsongallery").val());
    galeria.files = galeria.files || [];
    galeria.files.push(response.fileName);
    $("#jsongallery").val(JSON.stringify(galeria)).change();
}