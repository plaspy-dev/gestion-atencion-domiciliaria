angular.module('m', [])
    .controller('DataSource', function ($scope) {
        $scope.init = function (variable) {
            $scope.source = window[variable];
        };
    });

function addDataSource(controllerName, data) {
    var $scope = angular.element($("#" + controllerName)).scope();
    $scope.$apply(function () {
        $scope.source = ($scope.source || []).concat(data);
    });
}

$(function () {
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_beginRequest(function (sender, args) {
        $.mobile.loading("show");
        $("#PM").panel("close");
    });

    prm.add_pageLoaded(function (sender, args) {
        var panels= args.get_panelsUpdated();
        for (var i = 0; i < panels.length; i++) {
            $("#" + panels[i].id).trigger("create");
        }
        $.mobile.loading("hide");
    });
});

$.extend({
    getUrlVars: function () {
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    },
    getUrlVar: function (name) {
        return $.getUrlVars()[name];
    },
    goURL: function (params) {
        pos = window.location.href.indexOf('?');
        url = pos == -1 ? location.href : location.href.slice(0, window.location.href.indexOf('?'));
        if (params == null)
            location.href = url;
        else location.href = url + "?" + params;
    }
});