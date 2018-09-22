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

    var $contentholder = $(".container");
    var $footer = $(".footer");

    function ordlg() {
        var height = $contentholder.offset().top + $contentholder.height();
        if (height > $(window).height())
            height = $(window).height();
        height -= 220;
        height = height + $(window).scrollTop();
        if (height < 50)
            height = 50;
        $(".dcplusbtn").css("top", height);
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
