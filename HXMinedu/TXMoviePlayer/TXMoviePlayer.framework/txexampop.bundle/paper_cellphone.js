(function($){
    window.prepare = function(){
        var i=0;

        var answer = $(".answer");
        answer.hide();

        var question = $(".question");
        var type = question.attr("type");
        question.addClass(type);

        $(".options").each(function(){
            var item=$(this);
            item.attr("id","options_"+i);
            i++;
            $("li",item).each(function(){
                var li=$(this);
                li.attr("question-type",type);
                li.attr("options-id",item.attr("id"));
                li.click(function(){
                    var li2=$(this);
                    var optionsId=li2.attr("options-id");
                    var type=li2.attr("question-type");
                    if(type=="single_choice"||type=="true_false"){
                        $("li").each(function(){
                            $(this).removeClass("selected");
                        });
                        $(".mark").each(function(){
                            $(this).removeClass("selected");
                        });
                        li2.addClass("selected");
                        $(".mark",li2).addClass("selected");
                    }else{
                        li2.toggleClass("selected");
                        $(".mark",li2).toggleClass("selected");
                    }

                });
            });
        });
    }

    window.submit = function () {
        var score=0;
        $(".question").each(function(){
            var t=$(this);
            var type=t.attr("type");
            if(type=="true_false"||type=="single_choice"){
                if($(".options li.selected",t).attr("code") && t.attr("answer").toLowerCase()==$(".options li.selected",t).attr("code").toLowerCase()){
                    score=score+parseInt(t.attr("score"));
                }
            }else if(type=="multi_choice"){
                var a="";
                $(".options li.selected",t).each(function(){
                    a=a+$(this).attr("code");
                });
                if(t.attr("answer").toLowerCase()==a.toLowerCase()){
                    score=score+parseInt(t.attr("score"));
                }
            }
        });
        $(".answer").each(function(){
            $(this).show();
        });
        $(".options").each(function(){
            var item=$(this);
            $("li",item).each(function(){
                var li=$(this);
                li.unbind();
            });
        });
        var questions=$(".popup-questions");
        var passScore=60;
        var status="0";
        if(score>=passScore){
            status="1";
        }
        return status;
    }
})(jQuery);
