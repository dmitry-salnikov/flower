/*global define:true */
define(["jquery","moment", "knob"],function($) {
    "use strict";
    var queue_timer  = null,
        track_timer  = null,
        volume_timer = null,
        url          = null;

    function queue(){
        $.get(url + "/queue/tracks").success(function(data){
            $("#queue ol").html($(data).map(function(){
                return "<li><span>" + titleFromJSON(this) + "</span></li>";
            }).get());
        });
        queue_timer = setTimeout(function(){
            queue();}, 5000);
    }

    function currentVolume(){
        $.get("/volume").success(function(data){
            var knob = $('.volume');
            if (knob.val() != data.volume) {
                knob.val(data.volume).trigger('change');
            };
        });
        volume_timer = setTimeout(function(){
            currentVolume();}, 5000);
    }

    function currentTrack(){
        $.get(url + "/player/track").success(function(data){
            if(!$.isEmptyObject(data) && data.title){
                $("#track-info").text(titleFromJSON(data));
            }else{
                $("#track-info").text("");
            }
        })
        track_timer = setTimeout(function(){
            currentTrack();}, 2000);
    }

    function search(trackName){
        var trackName = encodeURIComponent(trackName);
        $.get("http://ws.spotify.com/search/1/track.json?q="+trackName,function(data){
            var html = "";
            var tracks = data.tracks;
            $(tracks).each(function(i,elm){
                var track = $(elm)[0];
                var artists = "";
                $(track.artists).each(function(i,item){
                    artists += item.name + " ";
                });
                html += "<li><span class=\"pop\"><i class=\"fa fa-music\"></i> "+ parseInt(track.popularity * 100,10) +"</span><div class=\"track-info\"><span>"+ track.name + "</span> - <span>"+ artists +"</span><br>"+ track.album.name +" ("+ track.album.released +")<br><strong>"+ moment().hours(0).minutes(0).seconds(track.length).format("mm:ss") +"</strong> <a href=# data-track="+ track.href +"><br><i class=\"fa fa-plus\"></i>Queue</a></div></li>";
            });
            $("ul#result").html(html);
            $("ul#result a").on("click",function(evt){
                evt.preventDefault();
                $(this).parents("li").remove();
                $.post("/spotify/queue",{
                    uri: $(this).data("track")
                })
                .done(function(){
                    queue();
                });
            });

        });
    }
    function player(action){
        $.ajax({
            url: url + "/player/"+action,
            type: 'PUT'
        });
    }

    function setFilter(filter){
        var filterSearch = filter + $("#track").val();
        $("#track").val(filterSearch);
        search(filterSearch);
    }

    function titleFromJSON(json){
        return json.artists.join(", ") + " – " + json.title
    }

    $(function(){
        url = $('body').data('url')
        queue();
        $("input[type=text]").on("keyup",function(){
            search($("#track").val());
        });
        $("a[data-player]").on("click",function(){
            event.preventDefault();
            player($(this).data("player"));
        });
        $("a[data-filter]").on("click",function(){
            event.preventDefault();
            setFilter($(this).data("filter"));
        });
        search($("#track").val());
        currentTrack();
        currentVolume();
        $(".volume").knob({
            "release": function(volume){
                $.post("/volume",{
                    volume: volume
                })
            }
        });
    });
});
