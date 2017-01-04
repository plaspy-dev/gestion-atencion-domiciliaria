
function onselected(obj, datum) {
    console.log('onselected datum', datum);
    console.log('onselected obj', obj);
    if (!obj || !obj.target || !datum) return;
    var newVal = datum.value.toString();
    console.log('newVal', newVal);
    $(obj.target).val(newVal).change();
}

function initTypeahead(obj) {
    console.log('obj', obj);
    var optionsName = $(obj).attr('data-typeahead-name');
    var optionsJsonString = $(obj).attr('data-typeahead-options');
    var options = JSON.parse(optionsJsonString);

    console.log('optionsName', optionsName);
    console.log('options', options);

    var engine = new Bloodhound({
        local: options,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        datumTokenizer: function (datum) {
            return Bloodhound.tokenizers.whitespace(datum.text);
        }
    });
    engine.initialize();

    $(obj).typeahead({
        hint: true,
        highlight: true,
        minLength: 1
    },
        {
            name: optionsName,
            displayKey: 'text',
            source: engine.ttAdapter()
        })
        .on('typeahead:selected', function (thisObj, datum) {
            onselected(thisObj, datum);
        });;
}