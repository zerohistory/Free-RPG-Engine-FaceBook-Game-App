/*
 * jQuery Tooltip plugin 1.3
 *
 * http://bassistance.de/jquery-plugins/jquery-plugin-tooltip/
 * http://docs.jquery.com/Plugins/Tooltip
 *
 * Copyright (c) 2006 - 2008 Jörn Zaefferer
 *
 * $Id: jquery.tooltip.js 5741 2008-06-21 15:22:16Z joern.zaefferer $
 * 
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
;eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}(';(8($){j e={},9,m,B,A=$.2u.2g&&/29\\s(5\\.5|6\\.)/.1M(1H.2t),M=12;$.k={w:12,1h:{Z:25,r:12,1d:19,X:"",G:15,E:15,16:"k"},2s:8(){$.k.w=!$.k.w}};$.N.1v({k:8(a){a=$.1v({},$.k.1h,a);1q(a);g 2.F(8(){$.1j(2,"k",a);2.11=e.3.n("1g");2.13=2.m;$(2).24("m");2.22=""}).21(1e).1U(q).1S(q)},H:A?8(){g 2.F(8(){j b=$(2).n(\'Y\');4(b.1J(/^o\\(["\']?(.*\\.1I)["\']?\\)$/i)){b=1F.$1;$(2).n({\'Y\':\'1D\',\'1B\':"2r:2q.2m.2l(2j=19, 2i=2h, 1p=\'"+b+"\')"}).F(8(){j a=$(2).n(\'1o\');4(a!=\'2f\'&&a!=\'1u\')$(2).n(\'1o\',\'1u\')})}})}:8(){g 2},1l:A?8(){g 2.F(8(){$(2).n({\'1B\':\'\',Y:\'\'})})}:8(){g 2},1x:8(){g 2.F(8(){$(2)[$(2).D()?"l":"q"]()})},o:8(){g 2.1k(\'28\')||2.1k(\'1p\')}});8 1q(a){4(e.3)g;e.3=$(\'<t 16="\'+a.16+\'"><10></10><t 1i="f"></t><t 1i="o"></t></t>\').27(K.f).q();4($.N.L)e.3.L();e.m=$(\'10\',e.3);e.f=$(\'t.f\',e.3);e.o=$(\'t.o\',e.3)}8 7(a){g $.1j(a,"k")}8 1f(a){4(7(2).Z)B=26(l,7(2).Z);p l();M=!!7(2).M;$(K.f).23(\'W\',u);u(a)}8 1e(){4($.k.w||2==9||(!2.13&&!7(2).U))g;9=2;m=2.13;4(7(2).U){e.m.q();j a=7(2).U.1Z(2);4(a.1Y||a.1V){e.f.1c().T(a)}p{e.f.D(a)}e.f.l()}p 4(7(2).18){j b=m.1T(7(2).18);e.m.D(b.1R()).l();e.f.1c();1Q(j i=0,R;(R=b[i]);i++){4(i>0)e.f.T("<1P/>");e.f.T(R)}e.f.1x()}p{e.m.D(m).l();e.f.q()}4(7(2).1d&&$(2).o())e.o.D($(2).o().1O(\'1N://\',\'\')).l();p e.o.q();e.3.P(7(2).X);4(7(2).H)e.3.H();1f.1L(2,1K)}8 l(){B=S;4((!A||!$.N.L)&&7(9).r){4(e.3.I(":17"))e.3.Q().l().O(7(9).r,9.11);p e.3.I(\':1a\')?e.3.O(7(9).r,9.11):e.3.1G(7(9).r)}p{e.3.l()}u()}8 u(c){4($.k.w)g;4(c&&c.1W.1X=="1E"){g}4(!M&&e.3.I(":1a")){$(K.f).1b(\'W\',u)}4(9==S){$(K.f).1b(\'W\',u);g}e.3.V("z-14").V("z-1A");j b=e.3[0].1z;j a=e.3[0].1y;4(c){b=c.2o+7(9).E;a=c.2n+7(9).G;j d=\'1w\';4(7(9).2k){d=$(C).1r()-b;b=\'1w\'}e.3.n({E:b,14:d,G:a})}j v=z(),h=e.3[0];4(v.x+v.1s<h.1z+h.1n){b-=h.1n+20+7(9).E;e.3.n({E:b+\'1C\'}).P("z-14")}4(v.y+v.1t<h.1y+h.1m){a-=h.1m+20+7(9).G;e.3.n({G:a+\'1C\'}).P("z-1A")}}8 z(){g{x:$(C).2e(),y:$(C).2d(),1s:$(C).1r(),1t:$(C).2p()}}8 q(a){4($.k.w)g;4(B)2c(B);9=S;j b=7(2);8 J(){e.3.V(b.X).q().n("1g","")}4((!A||!$.N.L)&&b.r){4(e.3.I(\':17\'))e.3.Q().O(b.r,0,J);p e.3.Q().2b(b.r,J)}p J();4(7(2).H)e.3.1l()}})(2a);',62,155,'||this|parent|if|||settings|function|current||||||body|return|||var|tooltip|show|title|css|url|else|hide|fade||div|update||blocked|||viewport|IE|tID|window|html|left|each|top|fixPNG|is|complete|document|bgiframe|track|fn|fadeTo|addClass|stop|part|null|append|bodyHandler|removeClass|mousemove|extraClass|backgroundImage|delay|h3|tOpacity|false|tooltipText|right||id|animated|showBody|true|visible|unbind|empty|showURL|save|handle|opacity|defaults|class|data|attr|unfixPNG|offsetHeight|offsetWidth|position|src|createHelper|width|cx|cy|relative|extend|auto|hideWhenEmpty|offsetTop|offsetLeft|bottom|filter|px|none|OPTION|RegExp|fadeIn|navigator|png|match|arguments|apply|test|http|replace|br|for|shift|click|split|mouseout|jquery|target|tagName|nodeType|call||mouseover|alt|bind|removeAttr|200|setTimeout|appendTo|href|MSIE|jQuery|fadeOut|clearTimeout|scrollTop|scrollLeft|absolute|msie|crop|sizingMethod|enabled|positionLeft|AlphaImageLoader|Microsoft|pageY|pageX|height|DXImageTransform|progid|block|userAgent|browser'.split('|'),0,{}));

(function($){$.ajaxSettings.accepts._default="text/javascript, text/html, application/xml, text/xml, */*"})(jQuery);(function($){$.fn.reset=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};$.fn.enable=function(){return this.each(function(){this.disabled=false})};$.fn.disable=function(){return this.each(function(){this.disabled=true})}})(jQuery);(function($){$.extend({fieldEvent:function(el,obs){var field=el[0]||el,e="change";if(field.type=="radio"||field.type=="checkbox"){e="click"}else{if(obs&&(field.type=="text"||field.type=="textarea"||field.type=="password")){e="keyup"}}return e}});$.fn.extend({delayedObserver:function(delay,callback){var el=$(this);if(typeof window.delayedObserverStack=="undefined"){window.delayedObserverStack=[]}if(typeof window.delayedObserverCallback=="undefined"){window.delayedObserverCallback=function(stackPos){var observed=window.delayedObserverStack[stackPos];if(observed.timer){clearTimeout(observed.timer)}observed.timer=setTimeout(function(){observed.timer=null;observed.callback(observed.obj,observed.obj.formVal())},observed.delay*1000);observed.oldVal=observed.obj.formVal()}}window.delayedObserverStack.push({obj:el,timer:null,delay:delay,oldVal:el.formVal(),callback:callback});var stackPos=window.delayedObserverStack.length-1;if(el[0].tagName=="FORM"){$(":input",el).each(function(){var field=$(this);field.bind($.fieldEvent(field,delay),function(){var observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.oldVal){return}else{window.delayedObserverCallback(stackPos)}})})}else{el.bind($.fieldEvent(el,delay),function(){var observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.oldVal){return}else{window.delayedObserverCallback(stackPos)}})}},formVal:function(){var el=this[0];if(el.tagName=="FORM"){return this.serialize()}if(el.type=="checkbox"||el.type=="radio"){return this.filter("input:checked").val()||""}else{return this.val()}}})})(jQuery);(function($){$.fn.extend({visualEffect:function(o,options){if(options){speed=options.duration*1000}else{speed=null}e=o.replace(/\_(.)/g,function(m,l){return l.toUpperCase()});return eval("$(this)."+e+"("+speed+")")},appear:function(speed,callback){return this.fadeIn(speed,callback)},blindDown:function(speed,callback){return this.show("blind",{direction:"vertical"},speed,callback)},blindUp:function(speed,callback){return this.hide("blind",{direction:"vertical"},speed,callback)},blindRight:function(speed,callback){return this.show("blind",{direction:"horizontal"},speed,callback)},blindLeft:function(speed,callback){this.hide("blind",{direction:"horizontal"},speed,callback);return this},dropOut:function(speed,callback){return this.hide("drop",{direction:"down"},speed,callback)},dropIn:function(speed,callback){return this.show("drop",{direction:"up"},speed,callback)},fade:function(speed,callback){return this.fadeOut(speed,callback)},fadeToggle:function(speed,callback){return this.animate({opacity:"toggle"},speed,callback)},fold:function(speed,callback){return this.hide("fold",{},speed,callback)},foldOut:function(speed,callback){return this.show("fold",{},speed,callback)},grow:function(speed,callback){return this.show("scale",{},speed,callback)},highlight:function(speed,callback){return this.show("highlight",{},speed,callback)},puff:function(speed,callback){return this.hide("puff",{},speed,callback)},pulsate:function(speed,callback){return this.show("pulsate",{},speed,callback)},shake:function(speed,callback){return this.show("shake",{},speed,callback)},shrink:function(speed,callback){return this.hide("scale",{},speed,callback)},squish:function(speed,callback){return this.hide("scale",{origin:["top","left"]},speed,callback)},slideUp:function(speed,callback){return this.hide("slide",{direction:"up"},speed,callback)},slideDown:function(speed,callback){return this.show("slide",{direction:"up"},speed,callback)},switchOff:function(speed,callback){return this.hide("clip",{},speed,callback)},switchOn:function(speed,callback){return this.show("clip",{},speed,callback)}})})(jQuery);

var Timer = {
  timers: {},

  format: function(value){
    var days    = Math.floor(value / 86400);
    var hours   = Math.floor((value - days * 86400) / 3600);
    var minutes = Math.floor((value - days * 86400 - hours * 3600) / 60);
    var seconds = value - days * 86400 - hours * 3600 - minutes * 60;

    var result = '';

    if(days > 1){
      result = result + days + ' days, ';
    } else if(days > 0) {
      result = result + days + ' day, ';
    }

    if(hours > 0){
      result = result + hours + ":";
    }

    if(minutes < 10){
      result = result + "0" + minutes;
    }else{
      result = result + minutes;
    }

    if(seconds < 10){
      result = result + ":0" + seconds;
    }else{
      result = result + ":" + seconds;
    }

    return(result);
  },

  update: function(id){
    var element = $(id);

    if(element.length === 0){
      this.timers[id].running = false;

      return;
    }

    if(this.timers[id].value > 0){
      element.text(Timer.format(this.timers[id].value));

      this.timers[id].value = this.timers[id].value - 1;

      this.rerun(id);
    } else {
      element.text('');

      this.timers[id].running = false;

      if(this.timers[id].callback){
        this.timers[id].callback(element);
      }
    }
  },

  rerun: function(id){
    setTimeout(function() { Timer.update(id); }, 1000);
    
    this.timers[id].running = true;
  },

  start: function(id, value, callback){
    if(value == 0){ return; }

    if(this.timers[id]){
      this.timers[id].value = value;
      this.timers[id].callback = callback;
    } else {
      this.timers[id] = {value: value, running: false, callback: callback};
    }

    if(!this.timers[id].running){
      this.rerun(id);
    }
  }
};


var Spinner = {
  x: -1,
  y: -1,
  setup: function(){
    $('#spinner').ajaxStart(function(){
        Spinner.show();
      }).ajaxStop(function(){
        Spinner.hide();
      });
      
    $('body').mousemove(this.alignToMouse);
  },
  show: function(speed){
    Spinner.moveToPosition();

    $('#spinner').fadeIn(speed);
  },
  hide: function(speed){
    $('#spinner').fadeOut(speed);
  },
  blink: function(speed, delay){
    Spinner.moveToPosition();

    $('#spinner').fadeIn(speed).delay(delay).fadeOut(speed);
  },
  storePosition: function(x, y){
    Spinner.x = x;
    Spinner.y = y;
  },
  moveToPosition: function(){
    if(this.x > -1 && this.y > -1){
      $('#spinner').css({
        top: this.y - $('#spinner').height() / 2
      });
    }
  },
  alignToMouse: function(e){
    Spinner.storePosition(e.pageX, e.pageY);
  },
  alignTo: function(selector){
    var position = $(selector).offset();

    Spinner.storePosition(position.left, position.top);
  }
};


function if_fb_initialized(callback){
  if(typeof(FB) != 'undefined'){ 
    callback.call();
  } else { 
    alert('The page failed to initialize properly. Please reload it and try again.'); 
  }
}

function bookmark(){
  if(typeof(FB) != 'undefined'){
    FB.ui({method : 'bookmark.add'});
    $(document).trigger('facebook.dialog');
  }

  $.scrollTo('body');
}

function show_result(){
  $('#result').show();

  $.scrollTo('#result');
}

function signedUrl(url){
  var new_url = url + (url.indexOf('?') == -1 ? '?' : '&') + 'stored_signed_request=' + signed_request;

  return new_url;
}

function redirectTo(url){
  document.location = signedUrl(url);
}

function updateCanvasSize() {
  FB.Canvas.setSize({
    height: $('body').height() + 100 // Additional number compensates admin menu margin that is not included into the body height
  });
}


var CollectionList = {
  setup: function(){
    CollectionList.blurItems($('#item_collection_list').find('.info .item:not(.present)'));
  },

  blurItems: function(collection){
    collection.removeClass('present').children().css({opacity: 0.4, filter: ''});
  }
};


var CharacterForm = {
  setup: function(selector){
    var form = $(selector);

    form.find('#character_types .character_type').click(function(){
      CharacterForm.set_character_type(this);
    }).tooltip({
      id: 'tooltip',
      delay: 0,
      bodyHandler: function(){
        return $('#description_character_type_' + $(this).attr('value')).html();
      }
    });

    form.find('input[type=submit]').click(function(e){
      e.preventDefault();

      form.submit();

      Spinner.show(200);
    });

    form.find('a.skip').click(function(e){
      var link = e.target;

      e.preventDefault();

      redirectTo($(link).attr('href'));

      Spinner.show(200);
    });
  },

  set_character_type: function(selector){
    var $this = $(selector);

    $this.addClass('selected').siblings('.character_type').removeClass('selected');

    $('#character_character_type_id').val(
      $this.attr('value')
    );
  }
};


var Character = {
  update: function(a){
    var c = a.character;

    if(c === 'undefined'){ return; }
    
    $("#co .basic_money .value").text(c.formatted_basic_money);
    $("#main_menu .premium .value").text(c.formatted_vip_money);
    $("#bottom_nav .premium .value").text("(" + c.formatted_vip_money + ")");
    $("#co .experience .value").text(c.experience + "/" + c.next_level_experience);

    $("#co .experience .percentage_bar .complete").css({width: c.level_progress_percentage + "%"})

    $("#co .level .value").text(c.level);
    $("#co .health .value").text(c.hp + "/" + c.health_points);
    $("#co .energy .value").text(c.ep + "/" + c.energy_points);
    $("#co .stamina .value").text(c.sp + "/" + c.stamina_points);
    $("#co .defence .value").text(c.defence)
    $("#co .attack .value").text(c.attack)

    $("#co .energy .percentage_bar .complete").width((c.ep/c.energy_points)*100)
    $("#co .health .percentage_bar .complete").width((c.hp/c.health_points)*100)
    $("#co .stamina .percentage_bar .complete").width((c.sp/c.stamina_points)*100)

    Timer.start('#co .health .timer', c.time_to_hp_restore, this.update_from_remote);
    Timer.start('#co .energy .timer', c.time_to_ep_restore, this.update_from_remote);
    Timer.start('#co .stamina .timer', c.time_to_sp_restore, this.update_from_remote);

    $('#co .timer').unbind('click').click(Character.update_from_remote);

    if (c.points > 0) {
      $("#co .level .upgrade").show();
    } else {
      $("#co .level .upgrade").hide();
    }
    
    if (c.hp == c.health_points) {
      $('#co .health .hospital').hide();
    } else {
      $('#co .health .hospital').show();
    }
  },

  update_from_remote: function(){
    $.getJSON('/character_status/?rand=' + Math.random(), function(data){
      Character.update(data);
    });
  },

  initFightAttributes: function(){
    $('#fight_attributes .inventories .inventory').tooltip({
      delay: 0,
      track: true,
      showURL: false,
      bodyHandler: function(){
        return $('#' + $(this).attr('tooltip')).clone();
      }
    });
  }
};


var PropertyList = {
  enableCollection: function(timer_element){
    $(timer_element).parent('.timer').hide();
    $(timer_element).parents('.property_type').find('.button.collect').show();

    var collectables = $('#property_collect_all').find('.value');

    collectables.text(parseInt(collectables.text(), 10) + 1);
    collectables.parent().show();
  }
};


var BossFight = {
  initBlock: function(){
    $(document).bind({
      'boss.won': BossFight.onWin,
      'boss.lost': BossFight.onLose,
      'boss.expired': BossFight.onExpire
    });
  },
  onWin: function(event, fight_id){
    BossFight.hide_reminder(fight_id);
  },
  
  onLose: function(event, fight_id){
    BossFight.hide_reminder(fight_id);
  },

  onExpire: function(event, fight_id){
    BossFight.hide_reminder(fight_id);
  },

  hide_reminder: function(fight_id){
    $('#boss_fight_' + fight_id).hide();

    if($('#boss_fight_block .boss_fight:visible').length == 0){
      $('#boss_fight_block').hide();
    }
  }
};


var AssignmentForm = {
  setup: function(){
    $('#new_assignment .tabs').tabs();

    $('#new_assignment .relations .relation').click(AssignmentForm.select_relation);
  },

  select_relation: function(){
    $('#new_assignment .relations .relation').removeClass('selected');

    var $this = $(this);

    $this.addClass('selected');

    $('#assignment_relation_id').val($this.attr('value'));
  }
};


var GiftForm = {
  setup: function(){
    $('#allies .relations .relation').click(GiftForm.select_relation);
  },

  select_relation: function(){
    $('#allies .relations .relation').removeClass('selected');

    var $this = $(this);

    $this.addClass('selected');

    $('#relation_id').val($this.attr('value'));
  }
}

var Equipment = {
  setup: function(){
    $('#equippables .inventory, #placements .inventory').tooltip({
      delay: 0,
      track: true,
      bodyHandler: function(){
        return $(this).find('.tooltip_content').clone();
      }
    });
  }
};


var Mission = {
  requirementCallback: function(){},
  onRequirementSatisfy: function(){
    $(document).unbind('requirement.satisfy', Mission.onRequirementSatisfy);

    Mission.requirementCallback();
  },
  onItemPurchase: function(){
    $(document).unbind('item.purchase', Mission.onItemPurchase);
    $(document).trigger('requirement.satisfy');
  }
};


(function($){
  $.fn.missionGroups = function(current_group, show_limit){
    var $container = $(this);
    var $items = $container.find('li');
    var $current = $(current_group);

    $container.find('.container').jCarouselLite({
      btnNext:  $container.find('.next'),
      btnPrev:  $container.find('.previous'),
      visible:  show_limit,
      start:    Math.floor($items.index($current) / show_limit) * show_limit,
      circular: false
    });

    $current.addClass('current');

    $items.click(function(e){
      e.preventDefault();
      e.stopPropagation();

      redirectTo($(this).find('a').attr('href'));
    });
  };
  
  $.fn.giftButton = function(options){
    $(this).live('click', function(e){
      e.preventDefault();
      
      var $this = $(this);

      if_fb_initialized(function(){
        FB.ui({
          method: 'apprequests',
          title: options.request_title,
          message: $this.attr('data-message'),
          data: {
            type: 'gift',
            item_id: $this.attr('data-item-id')
          }
        }, function(response){
          if(typeof(response) != 'undefined' && response !== 'null'){
            $this.trigger('request_sent');
            
            $('#ajax').load(options.request_callback_url, {ids: response.request_ids, item_id: $this.attr('data-item-id')});
          }
        });

        $(document).trigger('facebook.dialog');
      });
    });
  };
  
  $.fn.giftForm = function(options){
    var $gifts = $(this).find('.gifts .gift');

    $gifts.css({
      height: $gifts.map(function(e){
          return $(this).outerHeight();
        }).toArray().sort().reverse()[0]
    });

    $gifts.find('.send').giftButton(options);
    
    return $(this);
  };
})(jQuery);


$(function(){
  if(document.cookie.indexOf('access_token') == -1){
    $('a').live('click', function(){
      var href = $(this).attr('href');
      
      if(typeof(href) != 'undefined'){
        $(this).attr('href', signedUrl(href));
      }
    });

    $('form').live('submit', function(){
      $(this).append('<input type="hidden" name="stored_signed_request" value="' + signed_request + '">');
    });

    $.ajaxSetup({
      beforeSend : function(request){
        request.setRequestHeader('signed-request', signed_request);
      }
    });
  }
  
  $('a[data-click-once=true]').live('click', function(){
    $(this).attr('onclick', null).css({opacity: 0.3, filter: '', cursor: 'wait'}).blur();
  });

  $(document).bind('facebook.ready', function(){
    window.setInterval(updateCanvasSize, 100);
  });

  $(document).bind('result.received', function(){
    $(document).trigger('remote_content.received');
    $(document).trigger('result.available');
  });

  $(document).bind('result.available', show_result);

  $(document).bind('remote_content.received', function(){
    if(typeof(FB) != 'undefined'){
      FB.XFBML.parse();
    }
  });

  $(document).bind('loading.dialog', function(){
    $.scrollTo('#dialog .popup');
  });
  
  $(document).bind('afterReveal.dialog', function(){
    $.scrollTo('#dialog .popup .body');
  });

  $(document).bind('facebook.dialog', function(){
    $(document).delay(100).queue(function(){  
      var dialog = $('.fb_dialog').filter(function(){ 
        return $(this).offset().top > 0;
      }).first();

      $.scrollTo(dialog);
      
      Spinner.alignTo(dialog);
      Spinner.blink();
    });
  });

  Spinner.setup();

  $('a.help').live('click', function(e){
    e.preventDefault();
    
    $.dialog({ajax: $(this).attr('href')});
  });

  $(document).bind('dialog.close_complete application.ready', function(){
    $(document).dequeue('dialog');
  });
});

