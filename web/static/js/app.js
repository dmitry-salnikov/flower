/*global define:true */
requirejs.config({
    "baseUrl": "js",
    "paths": {
      "jquery": "//cdn.jsdelivr.net/jquery/1.10.2/jquery-1.10.2.min",
      "moment": "//cdn.jsdelivr.net/momentjs/2.4.0/moment.min",
      "knob": "//cdn.jsdelivr.net/jquery.knob/1.2.9/jquery.knob.min"
    }
});
require(["spotify"], function(spotify) {
});
