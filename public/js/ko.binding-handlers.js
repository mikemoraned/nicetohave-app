(function(ko){
    ko.bindingHandlers.scrollToWhen = {
        update: function(element, valueAccessor, allBindingsAccessor) {
            var value = valueAccessor();
            var valueUnwrapped = ko.utils.unwrapObservable(value);

            if (valueUnwrapped == true)
            {
                var top = $(element).offset().top;
                $(".cards").animate({
                    scrollTop: top
                }, 1000);
            }
        }
    };
})(ko);