(function () {

    function getModelPrefix(fieldName) {
        return fieldName.substr(0, fieldName.lastIndexOf(".") + 1);
    }

    function appendModelPrefix(value, prefix) {
        if (value.indexOf("*.") === 0) {
            return value.replace("*.", prefix);
        }
        return prefix + value;
    }

    function escapeAttributeValue(value) {
        // As mentioned on http://api.jquery.com/category/selectors/
        return value.replace(/([!"#$%&'()*+,./:;<=>?@\[\\\]^`{|}~])/g, "\\$1");
    }

    jQuery.validator._getFormElement = function (form, element, field) {

        var prefix = getModelPrefix(element.name);
        fullOtherName = appendModelPrefix(field, prefix);
        return $(form).find(":input").filter("[name='" + escapeAttributeValue(fullOtherName) + "']");
    }

    jQuery.validator.addMethod('requiredif',
        function (value, element, params) {
            // Get element value. Classic genre has value '0'.
            var elements = params.split(',');
            for (var i = 0; i < elements.length; i++) {
                var fieldvalue = jQuery.validator._getFormElement(element.form, element, elements[i]).val();
                if (fieldvalue) {
                    return !!value;
                }
            }
            return true;
        });

    jQuery.validator.unobtrusive.adapters.add('requiredif',
        ['fields'],
        function (options) {
            /*var prefix = getModelPrefix(options.element.name),
                other = options.params.field,
                fullOtherName = appendModelPrefix(other, prefix),
                element = $(options.form).find(":input").filter("[name='" + escapeAttributeValue(fullOtherName) + "']")[0];*/
            options.rules['requiredif'] = options.params.fields;
            if (options.message)
                options.messages['requiredif'] = options.message;
        });

    /*
function ValidateTest(value, element, form) {
    return false;
}
     */

    function addMethodValidator(number) {

        jQuery.validator.addMethod('methodvalidator' + number,
            function (value, element, params) {
                // Get element value. Classic genre has value '0'.
                var method = params[0];
                if (method && window[method]) {
                    return window[method](value, element, params[1]);
                }
                return true;
            });

        jQuery.validator.unobtrusive.adapters.add('methodvalidator' + number,
            ['method'],
            function (options) {
                options.rules['methodvalidator' + number] = [options.params['method'], options.form];
                if (jQuery.validator.overwriteMethodMessage && jQuery.validator.overwriteMethodMessage[options.params['method']])
                    options.messages['methodvalidator' + number] = jQuery.validator.overwriteMethodMessage[options.params['method']];
                else options.messages['methodvalidator' + number] = options.message;
            });
    }

    addMethodValidator("");
    addMethodValidator("a");
    addMethodValidator("b");
    addMethodValidator("c");
    addMethodValidator("d");
    addMethodValidator("e");

    jQuery.validator.addMethod('datelessthan',
        function (value, element, params) {
            var date = moment(value, 'DD/MM/YYYY HH:mm');
            /*if (!date.hour() && !date.minute() && !date.second()) {
                date.hour(23);
                date.minute(59);
                date.second(59);
            }*/
            date = date.toDate();
            if (!date)
                return true;
            if (date > new Date()) {
                element.__datelessthan = new Date();
                return false;
            }
            var fields = params;
            if (fields) {
                var _fields = fields.split(",");
                var prefix = getModelPrefix(element.name);

                for (var i = 0; i < _fields.length; i++) {
                    var fullOtherName = appendModelPrefix(_fields[i], prefix);
                    var value = $(this.currentForm).find(":input").filter("[name='" + escapeAttributeValue(fullOtherName) + "']").val();
                    if (value) {
                        var fielddate = moment(value, 'DD/MM/YYYY HH:mm').toDate();
                        if (fielddate && date > fielddate) {
                            // error de fecha
                            element.__datelessthan = value;
                            return false;
                        }
                    }
                }
            }
            return true;
        });

    jQuery.validator.unobtrusive.adapters.add('datelessthan',
        ['fields'],
        function (options) {
            options.rules['datelessthan'] = options.params['fields'];
            options.messages['datelessthan'] = function (parameters, element) {
                var text = element.__datelessthan;
                if (text instanceof Date) {
                    text = moment(text).format("DD/MM/YYYY HH:mm");
                }
                return options.message.replace("{0}", text);
            };
        });


    jQuery.validator.addMethod('dategreaterthan',
        function (value, element, params) {
            var date = moment(value, 'DD/MM/YYYY HH:mm');
            if (!date.hour() && !date.minute() && !date.second()) {
                date.hour(23);
                date.minute(59);
                date.second(59);
            }
            date= date.toDate();
            if (!date)
                return true;
            var fields = params;
            if (fields) {
                var _fields = fields.split(",");
                var prefix = getModelPrefix(element.name);

                for (var i = 0; i < _fields.length; i++) {
                    var fullOtherName = appendModelPrefix(_fields[i], prefix);
                    var value = $(this.currentForm).find(":input").filter("[name='" + escapeAttributeValue(fullOtherName) + "']").val();
                    if (value) {
                        var fielddate = moment(value, 'DD/MM/YYYY HH:mm').toDate();
                        if (fielddate && date < fielddate) {
                            // error de fecha
                            element.__dategreaterthan = value;
                            return false;
                        }
                    }
                }
            }
            return true;
        });

    jQuery.validator.unobtrusive.adapters.add('dategreaterthan',
        ['fields'],
        function (options) {
            options.rules['dategreaterthan'] = options.params['fields'];
            options.messages['dategreaterthan'] = function (parameters, element) {
                var text = element.__dategreaterthan;
                if (text instanceof Date) {
                    text = moment(text).format("DD/MM/YYYY HH:mm");
                }
                return options.message.replace("{0}", text);
            };
        });
})();