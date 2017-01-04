<%@ Page Title="Test" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test_test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <%: Scripts.Render("~/js/f") %>
    <script type="text/javascript">

        /*$.fn.typeahead.Constructor.prototype.select = function () {
            var val = this.$menu.find('.active').attr('data-value');
            if (val) {
                this.$element
                    .val(this.updater(val))
                    .change();
            }
            return this.hide()
        };
        var newRender = function (items) {
            var that = this

            items = $(items).map(function (i, item) {
                i = $(that.options.item).attr('data-value', item);
                i.find('a').html(that.highlighter(item));
                return i[0];
            });

            this.$menu.html(items);
            return this;
        };
        $.fn.typeahead.Constructor.prototype.render = newRender;*/


        Funcionario({ controlId: "<%=TPrueba.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/RH")%>", controlDataId: "<%=TPruebaId.ClientID %>"});
        $(function () {
        });

        var substringMatcher = function (strs) {
            return function findMatches(q, cb) {
                var matches, substringRegex;

                // an array that will be populated with substring matches
                matches = [];

                // regex used to determine if a string contains the substring `q`
                substrRegex = new RegExp(q, 'i');

                // iterate through the pool of strings and for any string that
                // contains the substring `q`, add it to the `matches` array
                $.each(strs, function (i, str) {
                    if (substrRegex.test(str)) {
                        matches.push(str);
                    }
                });

                cb(matches);
            };
        };

        var states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
          'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii',
          'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
          'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
          'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
          'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
          'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
          'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
          'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
        ];

        var creditors = new Bloodhound({
            datumTokenizer: function (d) {
                return Bloodhound.tokenizers.whitespace(d.value)
            },
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            remote: {
                url: "../webservices/servicios.asmx/RH#%QUERY",
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

        $(function() {
            $('#the-basics .typeahead').typeahead({
                hint: true,
                highlight: true,
                minLength: 3
            },
            {
                display: 'Nombre',
                source: creditors
            }).on('typeahead:selected', function (e, datum) {
                console.log(datum);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <div id="the-basics">
        <input class="typeahead" type="text" placeholder="States of USA" />
    </div>
    <asp:TextBox runat="server" ID="TPrueba"></asp:TextBox>
    <asp:TextBox runat="server" ID="TPruebaId"></asp:TextBox>
</asp:Content>