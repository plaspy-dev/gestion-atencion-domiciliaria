$(function () {
    $.fn.btnBottomRight = function () {
        this.each(function () {
            var $button = $(this);
            var $ueg = $button.closest(".modal");
            if ($ueg.length > 0 && $ueg.is(":visible")) {
                var height = $ueg.find(".modal-content").offset().top + $ueg.find(".modal-content").height();
                if (height > $(window).height())
                    height = $(window).height();
                else height -= 20;
                height = height - 220 + $ueg.scrollTop();
                if (height < 50)
                    height = 50;
                $button.css("top", height);
            }
        });
        return this;
    };

    var $contentholder = $("._container");
    var $footer = $(".footer");
    var $buttondcpluss = $(".dcplusbtn");

    function ordlg() {
        var height = $contentholder.offset().top + $contentholder.height();
        if (height > $(window).height())
            height = $(window).height();
        height = height + $(window).scrollTop();
        if (height > $footer.offset().top)
            height = $footer.offset().top;
        height -= 220;

        if (height < 50)
            height = 50;

        var maxwidth = $(window).width() + $(window).scrollLeft();
        $buttondcpluss.css("right", 30 + $(document).width() - maxwidth);
        
        $buttondcpluss.css("top", height);
        $(".dcplusbtnm").btnBottomRight();
    }

    $(window).resize(function () {
        var height = $(window).height() - $contentholder.offset().top - $footer.height() - 32;
        if ($(window).width() < 1280)
            height -= 10;
        $contentholder.css("min-height", height);
        ordlg();
    }).scroll(ordlg).resize();
});
