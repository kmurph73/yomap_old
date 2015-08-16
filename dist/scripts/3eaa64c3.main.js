(function(){var a;"9000"===location.port?a="http://localhost:4567":(a="http://107.170.247.145",console.log("success!"))}).call(this),function(){var a,b,c,d,e;window.App=a={},a.data=c={},e={},_.extend(e,Backbone.Events),a.vent=e,$(function(){return $(document).on("mouseenter",".tip",function(){return $(this).tooltip().tooltip("show")}),$(document).on("mouseleave",".tip",function(){return $(this).tooltip("hide")})}),b=[36.641874,-119.25006],d=function(){var a;return a={zoom:5,center:new google.maps.LatLng(b[0],b[1]),mapTypeId:google.maps.MapTypeId.TERRAIN},c.map=new google.maps.Map(document.getElementById("map-canvas"),a)},google.maps.event.addDomListener(window,"load",d)}.call(this),function(){$(function(){return App.territories=new App.TerritoryList,new App.InputView,new App.TerritoriesView,App.mapView=new App.MapView})}.call(this),function(){var a,b,c,d,e,f,g,h,i,j,k;a=this.App,k=this._,g=this.google.maps,b=g.LatLng,e=function(a){return k.map(a,function(a){return new b(a[1],a[0])})},f=function(a){return k.map(a,function(a){var b,c,d,f,g,i;for(c=[],f=e(h(a.outerCoords)),d=k.map(a.innerCoords,function(a){return e(h(a))}),c.push(f),g=0,i=d.length;i>g;g++)b=d[g],c.push(b);return c})},h=function(a){return k.reject(a,function(a){return a.length<2})},j="https://s3-us-west-2.amazonaws.com/yodap",i=function(a){return a*Math.PI/180},d=function(a,b){var c,d,e,f,g,h;return c=6378137,g=i(b.lat()-a.lat()),h=i(b.lng()-a.lng()),d=Math.sin(g/2)*Math.sin(g/2)+Math.cos(i(a.lat()))*Math.cos(i(b.lat()))*Math.sin(h/2)*Math.sin(h/2),e=2*Math.atan2(Math.sqrt(d),Math.sqrt(1-d)),f=c*e},a.Territory=c=Backbone.Model.extend({initialize:function(){return this.set("polygons",[])},defaults:{loaded:!1},getCenter:function(){var a,b,c,d,e,f;for(a=new g.LatLngBounds,d=this.polygons,c=d[0][0],e=0,f=c.length;f>e;e++)b=c[e],a.extend(b);return a.getCenter()}}),c.fetchCountry=function(a,b){var c;return c=""+j+"/countries/"+a.get("abbrev")+".json",$.getJSON(c).then(function(a){var c;return c=f(a.polygons),b(c)})},c.fetchCity=function(a,b){var c;return c=""+j+"/cities/"+a.get("country")+"/"+a.get("state")+"/"+a.get("terse")+".json",$.getJSON(c).then(function(a){var c;return c=f(a.polygons),b(c)}).fail(function(){})},c.fetchState=function(a,b){return $.getJSON(""+j+"/states/"+a.get("abbrev")+".json").then(function(a){var c;return c=f(a.polygons),b(c)})}}.call(this),function(){var a,b,c;a=this.App,c=this._,b=a.Territory,a.TerritoryList=Backbone.Collection.extend({initialize:function(){return a.vent.on("removeTerritory",this.removeTerritory,this)},model:b,findByAttr:function(a,b){return null==b&&(b="name"),this.find(function(c){return c.get(b)===a})},findOrCreate:function(a){var b;return b=this.findWhere({abbrev:a.abbrev,state:a.state,country:a.country,type:a.type}),b||(b=this.add(a)),b},gotime:function(c){var d;return d=c.get("type"),c.data?a.vent.trigger("renderPolygon",c):"country"===d?b.fetchCountry(c,function(b){return c.polygons=b,a.vent.trigger("renderPolygon",c)}):"state"===d?b.fetchState(c,function(b){return c.polygons=b,a.vent.trigger("renderPolygon",c)}):"city"===d?b.fetchCity(c,function(b){return c.polygons=b,a.vent.trigger("renderPolygon",c)}):void 0},addList:function(a,c){var d,e,f,g,h;for(h=[],f=0,g=a.length;g>f;f++)e=a[f],d=new b(e),d.set(c),h.push(this.add(d));return h},setAll:function(a){var b,c,d,e,f,g,h,i;i=[];for(g in a)e=a[g],"countries"===g?h="country":"cities"===g?h="city":"states"===g&&(h="states"),"countries"===g?(b={type:h},i.push(this.addList(e,b))):i.push(function(){var a,g,i;for(i=[],a=0,g=e.length;g>a;a++)c=e[a],i.push(function(){var a;a=[];for(d in c)f=c[d],b={type:h,country:d},a.push(this.addList(f,b));return a}.call(this));return i}.call(this));return i},getNames:function(a){var b,d,e,f,g,h;if(d=[],c.isArray(a)){for(b=[],e=g=0,h=a.length;h>g;e=++g)f=a[e],b[e]=this.where({type:f});d=c.flatten(b)}else this.where({name:a});return c.map(d,function(a){return a.get("name")})}})}.call(this),function(){var a,b,c;a=this.App,c=this._,b=function(a){var b;return b=function(b,c){var d,e,f,g,h,i;for(d=void 0,g=void 0,d=[],f=new RegExp(b.replace(/\s/,""),"i"),h=0,i=a.length;i>h;h++)if(e=a[h],f.test(e.terse)){if(d.length>20)break;d.push({value:e.name,place:e})}return c(d)}},a.InputView=Backbone.View.extend({el:"#side",initialize:function(){var c,d=this;return c=a.territories.getNames(["state","country","city"]),a.territories.on("remove",this.clearInput,this),a.vent.on("renderPolygon",this.clearInput,this),$.ajax({type:"GET",dataType:"json",url:"https://s3-us-west-2.amazonaws.com/yodap/places.json.gz",success:function(a){return $("input#countryInput").typeahead({hint:!0,highlight:!0,minLength:1},{name:"places",source:b(a)}).on("typeahead:selected",d.selected)}})},selected:function(b,c){var d,e;return d=$(b.currentTarget),d.val(""),e=a.territories.findOrCreate(c.place),a.territories.gotime(e)},clearInput:function(){return $("input#countryInput").val("")}})}.call(this),function(){var a,b,c;a=this.App,c=this._,b=a.data,a.MapView=Backbone.View.extend({el:"#map-canvas",initialize:function(){return a.vent.on("renderPolygon",this.renderTerritory,this),a.territories.on("remove",this.removeTerritory,this),a.vent.on("resetTerritory",this.resetTerritory,this),a.vent.on("centerTerritory",this.centerTerritory,this),a.vent.on("gotoTerritory",this.gotoTerritory,this)},removeTerritory:function(a){var b,c,d,e,f;for(e=a.get("polygons"),f=[],c=0,d=e.length;d>c;c++)b=e[c],f.push(b.setMap(null));return f},resetTerritory:function(a){return this.removeTerritory(a),this.renderTerritory(a)},renderPolygon:function(a,b,c){var d;return d=new google.maps.Polygon({map:b,paths:c,strokeColor:"#FF0000",strokeOpacity:.8,strokeWeight:1,fillColor:"#FF0000",fillOpacity:.35,draggable:!0,geodesic:!0}),a.get("polygons").push(d)},renderTerritory:function(b){var c,d,e,f,g,h,i,j;for(d=a.data.map,c="#FF0000",f=b.get("type"),i=b.polygons,j=[],g=0,h=i.length;h>g;g++)e=i[g],j.push(this.renderPolygon(b,d,e));return j},gotoTerritory:function(a){var c,d,e;switch(c=b.map,c.setCenter(a.getCenter()),d=a.get("type")){case"city":e=10;break;case"state":e=5;break;case"country":e=4}return c.setZoom(e)},centerTerritory:function(){var b;return b=a.data.map,b.getCenter()},kmlRender:function(){var b;return b=new google.maps.FusionTablesLayer({query:{select:"geometry",from:"1JccYMnFShp8vhqqn3WC9JysW0vSEHC7cCQ9xK0pf"},options:{polygonOptions:{draggable:!0,geodesic:!0}},styles:[{polygonOptions:{fillColor:"#00FF00",draggable:!0,geodesic:!0}}]}),b.setMap(a.data.map)}})}.call(this),function(){var a,b;a=this.App,b=this._,a.TerritoriesView=Backbone.View.extend({el:"#open-territories",initialize:function(){return a.territories.on("add",this.render,this),a.territories.on("remove",this.render,this)},events:{"click .action":"clickAction"},render:function(){var b,c,d,e,f,g,h;for(b="<ul class='nav nav-pills'>",d=a.territories.models,c=g=0,h=d.length;h>g;c=++g)e=d[c],f=e.get("type"),b+="<li id='"+f+"_"+(e.get("abbrev")||e.get("terse"))+'\' class="territory-item dropdown">\n  <a id="drop4" role="button" data-toggle="dropdown" href="#">'+e.get("name")+'<span class="caret"></span></a>\n  <ul id="menu1" class="dropdown-menu" role="menu" aria-labelledby="drop4">\n    <li class=\'action reset\' role="presentation"><a role="menuitem" tabindex="-1" href="#">Reset</a></li>\n    <li class=\'action goto\' role="presentation"><a role="menuitem" tabindex="-1" href="#">Go to</a></li>\n    <li role="presentation" class="divider"></li>\n    <li class=\'action remove\' role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>\n  </ul>\n</li>';return b+="</ul>",this.$el.html(b)},clickAction:function(b){var c,d,e,f,g,h;return b.preventDefault(),e=this.$(b.currentTarget),d=e.closest(".territory-item").attr("id"),h=d.split("_"),g=h[0],c=h[1],"country"===g?f=a.territories.findWhere({type:g,abbrev:c}):"city"===g?f=a.territories.findWhere({type:g,terse:c}):"state"===g&&(f=a.territories.findWhere({type:g,abbrev:c})),e.hasClass("remove")?a.territories.remove(f):e.hasClass("reset")?a.vent.trigger("resetTerritory",f):e.hasClass("center")?a.vent.trigger("centerTerritory",f):e.hasClass("goto")?a.vent.trigger("gotoTerritory",f):void 0}})}.call(this);