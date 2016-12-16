requirejs.config({
    baseUrl: 'js',
    paths: {
        jquery: '../bower/js/jquery.min'
    }
});
require(["jquery", "app", "ui/ui"], ($, App)->
    $(document).ready(()->
        window.hydra = new App()
        hydra.start()
    )
)
