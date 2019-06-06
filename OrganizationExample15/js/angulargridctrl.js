getSafeAngularModule()
    .controller('GridList', function () {
        var controller = this;
        controller.list = [];
        controller.length = 0;
        var options = {};

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
            var selector = "";
            if (typeof (ctrlid) == "string") {
                selector = "#" + ctrlid;
            } else {
                options = ctrlid;
                selector = options.selector;
            }
            try {
                controller.list = JSON.parse($(selector).val());
                for (var i = 0; i < controller.list.length; i++) {
                    controller.list[i]["$$hashKey"] = null;
                }
            } catch (e) { }
            update();
        };
        controller.onAdd = function () {

            if (!controller.json)
                return;
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
            if (options.onAdd && window[options.onAdd])
                window[options.onAdd](row, options);
        };

        controller.onEdit = function (row) {
            if (window.onEdit)
                onEdit(row);
            if (options.onEdit && window[options.onEdit])
                window[options.onEdit](row, options);
        };
        controller.onPreDelete = function (row) {
            if (!confirm("¿Está seguro de eliminar esta línea?"))
                return;
            var index = controller.list.indexOf(row);
            if (index > -1)
                controller.list[index].eliminado = true;
            update();
            if (options.onDelete && window[options.onDelete])
                window[options.onDelete](row, options);
        };

        controller.onDelete = function (row) {
            if (!confirm("¿Está seguro de eliminar esta línea?"))
                return;
            var index = controller.list.indexOf(row);
            if (index > -1)
                controller.list.splice(index, 1);
            update();
            if (options.onDelete && window[options.onDelete])
                window[options.onDelete](row, options);
        };
    });