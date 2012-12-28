var express = require("express");
var app = express();

// Reference
// http://expressjs.com/guide.html
// https://github.com/spadin/simple-express-static-server
// http://devcenter.heroku.com/articles/node-js

// Configuration
app.configure(function(){

    app.use(express.static(__dirname + '/public'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());

    // LESS Support
    //app.use(express.compiler({ src: __dirname + '/public', enable: ['less'] }));
    // Template-enabled html view (by jade)
    // http://stackoverflow.com/questions/4529586/render-basic-html-view-in-node-js-express
    app.set('views', __dirname + '/views');
    app.set("view options", {layout: false});
    app.set('view engine', 'ejs');
    app.engine('html', require('ejs').renderFile);

    //Error Handling
    app.use(express.logger());
    app.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
    }));

    //Setup the Route, you are almost done
    app.use(app.router);
});

app.get('/', function(req, res){
    res.render("index");
});

app.get('/app', function(req, res){
    res.render("app");
});

//Heroku
var port = process.env.PORT || 3000;
app.listen(port, function() {
    console.log("Listening on " + port);
});