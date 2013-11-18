/*global define:true */
requirejs.config({
    "baseUrl": "js",
    "paths": {
      "jquery": "//cdn.jsdelivr.net/jquery/1.10.2/jquery-1.10.2.min"
    }
});
require(["spotify"], function(spotify) {
});
