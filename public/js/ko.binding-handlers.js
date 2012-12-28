(function(ko){
    ko.bindingHandlers.scrollToWhen = {
        update: function(element, valueAccessor, allBindingsAccessor) {
            var value = valueAccessor();
            var valueUnwrapped = ko.utils.unwrapObservable(value);

            var allBindings = allBindingsAccessor();

            if (valueUnwrapped == true && allBindings.scrollable)
            {
                var top = $(element).offset().top;
                $(allBindings.scrollable).animate({
                    scrollTop: top
                }, 1000);
            }
        }
    };
})(ko);