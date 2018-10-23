getSafeAngularModule()
    .controller('GridList', function () {
        var controller = this;
        controller.list = [];
        controller.length = 0;

        function update() {
            controller.length = 0;
            for (var i = 0; i < controller.list.length; i++) {
                controller.list[i]._aid = i + 1;
                if (!controller.list[i].eliminado)
                    controller.length++;
            }
            controller.result = JSON.stringify(controller.list);
        }

        controller.filterDeleted = function (row) {
            return !row.eliminado;
        };

        controller.init = function (ctrlid) {
            try {
                controller.list = JSON.parse($("#" + ctrlid).val());
                for (var i = 0; i < controller.list.length; i++) {
                    controller.list[i]["$$hashKey"] = null;
                }
            } catch (e) { }
            update();
        };
        controller.onAdd = function () {

            var info = JSON.parse(controller.json);
            if (info._aid) {
                var currentIndex = controller.list.findIndex(function (x) { return x._aid == info._aid; });
                if (currentIndex!=-1) {
                    controller.list[currentIndex] = info;
                } else {
                    controller.list.push(info);
                }
            } else {
                controller.list.push(info);
            }
            controller.json = "";
            update();
        };

        controller.onEdit = function (row) {
            if (window.onEdit)
                onEdit(row);
        };
        controller.onPreDelete = function (row) {
            if (!confirm("¿Está seguro de eliminar esta línea?"))
                return;
            var index = controller.list.indexOf(row);
            if (index > -1)
                controller.list[index].eliminado = true;
            update();
        }

        controller.onDelete = function (row) {
            if (!confirm("¿Está seguro de eliminar esta línea?"))
                return;
            var index = controller.list.indexOf(row);
            if (index > -1)
                controller.list.splice(index, 1);
            update();
        };
    });