var express = require("express");
var app = express();
var p = require('./package.json');
var engine = require('ejs-locals');
var lessMiddleware = require('less-middleware');

// Configuration
app.configure(function(){

    app.use(express.static(__dirname + '/public'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());

    // LESS Support
    app.use(lessMiddleware({
        src: __dirname + '/public',
        compress: true
    }));

    app.set('views', __dirname + '/views');
    app.set("view options", {layout: false});
    app.set('view engine', 'ejs');
    app.engine('ejs', engine);

    app.set('version', p.version);
    app.set('baseURL', p.baseURL);

    //Error Handling
    app.use(express.logger());
    app.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
    }));

    app.use(app.router);
});

app.get('/', function(req, res){
    res.render("index");
});

app.get('/app-old', function(req, res){
    res.render("app-old");
});

app.get('/app', function(req, res){
    res.render("app");
});

app.get('/history', function(req, res){
    res.render("history");
});

//Heroku
var port = process.env.PORT || 3000;
app.listen(port, function() {
    console.log("v" + p.version + " listening on " + port);
});