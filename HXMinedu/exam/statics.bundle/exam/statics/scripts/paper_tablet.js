(function($) {
     window.__RTE=null;
     var top=0;
     function connectWebViewJavascriptBridge(callback) {
         if (window.WebViewJavascriptBridge) {
             callback(WebViewJavascriptBridge)
         } else {
             document.addEventListener('WebViewJavascriptBridgeReady', function() {
                                   callback(WebViewJavascriptBridge)
                                   }, false)
         }
     }
	 
	
	window.__Exam_PaperInit=function(){

        connectWebViewJavascriptBridge(function(bridge) {
            bridge.init(function(message, responseCallback) {})
            window.__RTE = bridge;
			var paper = window.document;
            bridge.callHandler('isEnterExam', {'foo': 'bar'}, function(response) {
                   if(response == '1'){
                       rejectSaveAnswerEvent();
                       InitMobileExamAnswers();
					   initPainteButtonsAction();
                   }else{
                       $('.ui-question-textarea', paper).attr('disabled','disabled');
                       initMobileResultAnswers();
                   }
             })
			 
//			 $("#btn_open_painter").click(function(){
//                bridge.callHandler('enterPainterApp',  {'qId': $(this).attr('id')}, function(response) {})
//            })
                                       
             //新增画板支持
            bridge.registerHandler("uploadedCallBack", function(data)
            {
               var bridgeNew = window.__RTE;
               var qId = data["qId"];
               var uploadName = data["uploadName"];
               var baseUrl = data["baseurl"];

               var t=$('#'+qId), ul=$('ul[class=ui-file-list]',t),textarea=$('textarea',t);
               
               if(ul.length==0){
               ul=$('<ul class="ui-file-list"></ul>');
               textarea.after(ul);
               }
               $('img',$('.ui-question-attach',t)).remove();
               ul.empty();
			   
			   var values=uploadName.split(','),length=values.length;
               for(var it=0;it<length;it++){
				   
				   var imageName = values[it];
                   imageName=imageName.split('/')[0];
				   
	               if(uploadName){
					 var li=$('<li></li>');
                     li.append($('<input></input>').attr('type','hidden').attr('name','filePath').val(imageName));
                                   
                     // li.append('<img id="'+qId+'" src="\/exam\/student\/exam\/question\/attaches\/upload\/file\/-9\/filePath?__id='+uploadName+'"/>');
                                   
                     li.append($('<img id="'+qId+'" src="'+baseUrl+'\/exam\/student\/exam\/question\/attaches\/upload\/file\/01\/filePath?__id='+imageName+'"/>').on('click',function(){
                                                                             bridgeNew.callHandler('viewAttachImage', {'src': $(this).attr('src'),'qId': $(this).attr('id')}, function(response){})
                                                                            }));
                   
                     ul.append(li);
                   }
			   }
			   

                                   
               bridgeNew.callHandler('SaveItem', {'qId1': qId+'','psqId1':t.attr('code').substring(4),'answer':textarea.val()+"  ",'attach':uploadName}, function(response){})
            })
			
			
			bridge.registerHandler("ShowQuestionById",function(data){
				var qId = data["qId"];
				var self = this;
				var doc = window.document;
				var current = null;
				if (qId != 0) {
					current = $('#q_' + qId, doc);
				}
				if (!current || current.length == 0) {
					current = $('.ui-question:first', doc);
				}
				var top = current.offset().top;
				$(document).scrollTop(top);
				
			})
			
        })
 
        InitAudioLinks();
	};
	
/*初始化音频文件*/
	InitAudioLinks=function(){
        var audios=$('a[href$=".mp3"],a[href$=".MP3"],a[href$=".m4a"],a[href$=".M4A"]');
        if(audios && audios.length>0){
            for(var i=0; i<audios.length; i++) {
                var instance=$(audios[i]), url=instance.attr("href");
                instance.removeAttr("target").addClass('ui-audio-link');
                instance.attr("href","javascript:void(0)").attr("data-url",url);
                instance.on('click',function(event){
                            event.preventDefault();
                            window.location.href=$(this).data('url');
                    });
            };
        }
	}
	
	initPainteButtonsAction = function(){
		
		$('.ui-question-3').each(function(){
			
				var t=$(this),textarea=$('.ui-question-textarea',t),uploadDiv=$('<div for="'+t.attr('id')+' class="ui-input ui-widget ui-upload-widget"></div>');
				var att=$('.ui-question-attach',t);
				var button=$('<button type="button" class="ui-button-secondary ui-action-draw">启动画板输入</button>');
						button.on('click',function(){
							var bridge=window.__RTE;
							bridge.callHandler('enterPainterApp',  {'qId': t.attr('id')}, function(response) {})
						})
				uploadDiv.append('<ul class="ui-file-list"></ul>');
				if(att.length==0){
					textarea.after(uploadDiv.append(button));
				}else{
					att.after(uploadDiv);
					if($('a',att).length==0){
						uploadDiv.after(button);
					}
				}
			})
		
	}
	
	function rejectSaveAnswerEvent(){
		var bridge=window.__RTE;
        var paper = window.document;
		//点击选项，也可以选中答案
		$('.ui-question-options>li', paper).on('click',function(e){
				e.preventDefault();
				var t=$(this),parent=t.parent().parent(),answer='',isChanged=false;
				if(!!parent){
					if(parent.hasClass('ui-question-1')){
						if(!t.hasClass('ui-option-selected')){
							$('.ui-question-options>li.ui-option-selected', parent).removeClass('ui-option-selected');
							t.addClass('ui-option-selected');
							answer=t.attr('code');
							isChanged=true;
                                               
						}
                                               
					}else if(parent.hasClass('ui-question-2')){
						isChanged=true;
						t.toggleClass('ui-option-selected');
						$('.ui-question-options>li.ui-option-selected',parent).each(function(){
							answer=answer+$(this).attr('code');
						});
					}
					if(isChanged){
                        bridge.callHandler('SaveItem', {'qId1': parent.prop('id').substring(2),'psqId1':parent.attr('code').substring(4),'answer':answer}, function(response){})
                               
					}
				}
		});

		$('.ui-question-textarea', paper).on('change',function(){
            var parent=$(this).parent();
			if(!!parent){
				var answer=$(this).val();
                bridge.callHandler('SaveItem', {'qId1': parent.prop('id').substring(2),'psqId1':parent.attr('code').substring(4),'answer':answer}, function(response){})
			}
		});
	};

	function InitMobileExamAnswers() {
		var paper = window.document;
		var exam = window.__RTE;
		var qs = $('.ui-question', paper);
		for ( var j = 0; j < qs.length; j++) {
			var q = $(qs[j]);
			initMobileExamAnswer(q);
		}
	};
	function initMobileExamAnswer( q ) {
		var bridge=window.__RTE;
		var qid= q.attr('id').substring(2);
 
        bridge.callHandler('getUserAnswer', {'qid': qid}, function(response) {
           var ua = response;
           if(ua && ua!='null'){
               initUserAnswer(q, ua.answer);
           }
           if(q.hasClass('ui-question-3')&& ua){
               __showAnswerAttaches(qid,ua.file,ua.baseurl);
           }
           
        })
	};

	/** 设置题目答案 * */
	function initUserAnswer(question, answer) {
		if (question.hasClass('ui-question-1')) { // 单选题
			$('.ui-question-options>li[code="' + answer + '"]', question)
					.addClass('ui-option-selected');
		} else if (question.hasClass('ui-question-2')) { // 多选题
			$('.ui-question-options>li', question).each(function() {
				var t = $(this);
				if (answer.indexOf(t.attr('code')) != -1) {
					t.addClass('ui-option-selected');
				}
			});
		} else { // 问答题及其他
			$('.ui-question-textarea', question).val(answer);
		}
	}
	;
	
	function initMobileResultAnswers(){
        var paper = window.document;
		var bridge=window.__RTE;
 
		 var qs = $('.ui-question', paper);
		 var question3Key=[],question3FileAnswer={};
		 
		 for ( var j = 0; j < qs.length; j++) {
		   var q = $(qs[j]);
		   initMobileResultAnswer(q);
		 }
	};
	
	function initMobileResultAnswer(q){
		var bridge=window.__RTE;

		var qid= q.attr('id').substring(2);
		var uajson=null, qajson=null;
	 
		bridge.callHandler('getUserAnswer', {'qid': qid}, function(response) {
			var ua = response;
			if(!q.hasClass('ui-question-4')){  //不是复合题
			   if(ua && ua!='null' ){
				   initUserAnswer(q, ua.answer);
			   }
			}
			if(q.hasClass('ui-question-3')&& ua){
               __showAnswerAttaches(qid,ua.file,ua.baseurl);
			}

		})

	   bridge.callHandler('getQuestionAnswer', {'qid': qid}, function(response) {
		  var qa = response;
		  if(!q.hasClass('ui-question-4')){  //不是复合题
			  if(qa && qa!='null'){
				  var qajson =qa;// eval('('+qa+')');
				  showUserAnswerRightStatus(q, qajson);
				  bridge.callHandler('isAllowSeeAnswer', {'foo': 'bar'}, function(response) {
									 if(response == '1'){
									 showQuestionAnswerAndHint(q, qajson); //显示正确答案和提示
									 }
				  })
			  }
		  }
	   })
	}
	
	window.__OnKeybordHidden = function(){
		$(".ui-paper-wrapper").css({ height: $(".ui-paper-wrapper").height() - top }); 
		$(document).scrollTop(0);
		top=0;
	}
	
	window.lose_focus = function(){
		var txtObj =$('.ui-question-textarea');
		if(!!txtObj){
			txtObj.blur();}
	};
	function showQuestionAnswerAndHint(question, answer) {
		if (question.hasClass('ui-question-1')
				|| question.hasClass('ui-question-2')) {
			for ( var j = 0; j < answer.answer.length; j++) {
				var c = answer.answer.charAt(j);
				$('.ui-question-options>li[code=' + c + ']', question)
						.addClass('ui-correct-answer');
			}
		} else if (!question.hasClass('ui-question-4')) { // 非复合题
			question.append('<div class="ui-question-answer">答案：'
					+ answer.answer + '</div>');
		}
		if (!!answer.hint) {
			question.append('<div class="ui-question-hint">' + answer.hint
					+ '</div>');
		}
        InitAudioLinks();//重新显示超链接
		// reTranslate(); //重新显示公式符号
	}
	;
	function appendAnswerEmptyStatus(qt) {
		qt.append('<span class="ui-question-answer-error">您没有作答</span>');
	}
	;
	function appendAnswerRightStatus(qt) {
		qt.append('<span class="ui-question-answer-right">您答对了</span>');
	}
	;
	function appendAnswerErrorStatus(qt) {
		qt.append('<span class="ui-question-answer-error">您答错了</span>');
	}
	;
	function showUserAnswerRightStatus(question, answer) {
		var qt = $(".ui-question-title", question);
		if (answer.type == 1) {/* 单选题 */
			var sel = $('.ui-question-options>li.ui-option-selected', question);
			if (!sel || sel.length == 0) {
				appendAnswerEmptyStatus(qt);
			} else if (sel.attr("code") == answer.answer) {
				appendAnswerRightStatus(qt);
			} else {
				appendAnswerErrorStatus(qt);
			}
		} else if (answer.type == 2) {
			var temp = answer.answer;
			var sel = $('.ui-question-options>li.ui-option-selected', question);
			if (!sel || sel.length == 0) {
				appendAnswerEmptyStatus(qt);
			} else {
				sel.each(function() {
					var c = $(this).attr('code');
					if (temp.indexOf(c) < 0) {
						temp += c;
						return;
					} else {
						temp = temp.replace(c, '');
					}
				});
				if (temp.length == 0) {
					appendAnswerRightStatus(qt);
				} else {
					appendAnswerErrorStatus(qt);
				}
			}
		}
	}
	;
	
	function __showAnswerAttaches(keys,txtAnswerObj,baseUrl){
         var bridge=window.__RTE;
         if(!!keys){
                 var qid=keys,question=$('#q_'+qid),questionAnswer=$('.ui-question-textarea',question),value=txtAnswerObj;
                 if(!!value){
                     var content=$('<div class="ui-question-attach"></div>');
                     var values=value.split(','),length=values.length;
                     for(var it=0;it<length;it++){
                         var val=values[it],tmps=val.split('/');
                         if(tmps.length>0){
                             var __id=tmps[0],__name=(tmps.length>1?tmps[1]:tmps[0]);
 
                             if(!!__id.match(/.jpg|.jpeg|.png|.gif/gi)){
                                 content.append($('<img data-id="'+qid+'" src="'+baseUrl+'\/exam\/student\/exam\/question\/attaches\/upload\/file\/'+qid+'\/filePath?__id='+__id+'"/>').on('click',function(){
                                                                                                                                                                       bridge.callHandler('viewAttachImage', {'src': $(this).attr('src'),'qId': $(this).attr('id')}, function(response){})
                                                               }));
                             }else{
                                 var download=$('<a style="display:block;" href="javascript:void(0)" data-id="'+__id+'" data-url="'+baseUrl+'\/exam\/student\/exam\/question\/attaches\/upload\/file\/'+qid.substr(2)+'\/filePath?__id='+__id+'">'+__name+'</a>');
                                 download.click(function(){
                                                bridge.callHandler('downloadAttachFile', {'url': $(this).data('url'),'text':$(this).text()}, function(response){})
                                                });
                                 content.append(download);
                                 $('#btn_open_painter',question).hide();
                             }
                         }
                     }
                     questionAnswer.after(content);
                }
 
         }
 
	}
	
	
})(jQuery);