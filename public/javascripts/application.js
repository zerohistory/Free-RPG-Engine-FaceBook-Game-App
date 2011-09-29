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

