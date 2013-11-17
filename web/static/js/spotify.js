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
            html += "<li><span class=\"pop\">"+ parseInt(track.popularity * 100,10) +"</span><i class=\"fa fa-music\"></i> <span>"+ track.name + "</span> ("+ track.album.released +")<br><span>"+ artists +"</span><br><small>Length: "+ track.length +"</small> <a href=# data-track="+ track.href +">Load</a></li>";
        });
        $("ul#result").html(html);
        $("ul#result a").on("click",function(evt){
            evt.preventDefault();
            //console.log($(this).data("track"));
            $.post("/spotify/",{
                data:{track: $(this).data("track")}
            });
        });

    });
}
function setFilter(filter){
    var filterSearch = filter + $("#track").val();
    $("#track").val(filterSearch);
    search(filterSearch);
};
$(function(){
    $("input[type=text]").on("keyup",function(){
        search($("#track").val());
    });
    $("a[data-filter]").on("click",function(){
        event.preventDefault();
        setFilter($(this).data("filter"));
    });
});
