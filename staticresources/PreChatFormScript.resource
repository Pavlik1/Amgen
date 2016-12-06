var _removeBeforeSubmit = false;

function applyLogic() {
    if(typeof(laData.logic)!='undefined' && laData.logic!=null) {
        evaluateSubTrees();
        attachConditions(laFormData.formId);
    }
}

function evaluateSubTrees() {
    var qsize = laData.roots.length;
    for (var i = 0; i < qsize; i++) {
        var root = laData.roots[ i ];
        reEvaluateById(root);
    }
}

function getFormObject(formId) {
    return document.getElementById(formId);
}

function handleLogicOnSubmit(formId){
    _removeBeforeSubmit = true;
    evaluateSubTrees();
    return true;
}

function attachConditions(formId) {
    var formE = getFormObject(formId);
    var elems = null;
    if(formE!=null) elems = formE.elements;
    if(elems!=null){
        for (var i = 0; i < elems.length; i++) {
            var elType = elems[i].type.toLowerCase();
            if (elType == 'select-one') {
                elems[i].onchange = function() {
                    reEvaluate(this)
                };
            } else if (elType == 'radio' || elType == 'checkbox') {
                elems[i].onclick = function() {
                    reEvaluate(this)
                };
            }
        }
    }
}

function reEvaluateById(qid){
    //try find a select element
    var qobj = document.getElementById('q'+qid);
    //if not found, try find an input element
    if(qobj == null){
        qobj = document.getElementById('q'+qid+'r0');
    }
    if(qobj != null) {
        reEvaluate(qobj);
    }
}

function reEvaluate(obj) {
    if (obj.type.toLowerCase() == 'select-one') {
        reEvaluateSelectQuestion(obj);
    } else {
        reEvaluateInputQuestion(obj);
    }
}

/* function gets select object and iterate all answers */
function reEvaluateSelectQuestion(selectObj) {
    var start = laFormData.includeSelectOne ? 1 : 0; 
    for (var i = start; i < selectObj.options.length; i++) {
        if (selectObj.options[i].selected) {
            /*display the dependant questions*/
            var questions = getDependantQuestions(selectObj.id, i - start);
            if (questions != null) {
                displayQuestions(questions);
            }
        } else {
            /*hide the dependant trees*/
            var questions = getDependantQuestions(selectObj.id, i - start);
            if (questions != null) {
                hideQuestions(questions);
            }
        }
    }
}

/* function gets either radio or checkbox input and should iterate all answers */
function reEvaluateInputQuestion(inputObj) {
    var inputs = document.getElementsByName(inputObj.name);
    for(var i=0; i<inputs.length; i++) {
        var questionid = inputObj.id.substring(0, inputObj.id.indexOf('r'));
        if(inputs[i].checked){
            var questions = getDependantQuestions(questionid, i);
            if (questions != null) {
                displayQuestions(questions);
            }
        } else {
            var questions = getDependantQuestions(questionid, i);
            if (questions != null) {
                hideQuestions(questions);
            }
        }
    }
}

function getDependantQuestions(questionid, answerid) {
    /*here, remove the 'q' from the question id*/
    var qid = questionid.substring(1);
    var qsize = laData.logic.length;
    for (var i = 0; i < qsize; i++) {
        if (laData.logic[i].question == qid && laData.logic[i].answer == answerid) {
            return laData.logic[i].depQuestions;
        }
    }
    return null;
}

/* this is a recursive function to hide all questions in the array and all their trees */
function hideQuestions(questions) {
    for (var i = 0; i < questions.length; i++) {
        hideQuestion(questions[i]);
        var qsize = laData.logic.length;
        for (var j = 0; j < qsize; j++) {
            if (laData.logic[j].question == questions[i]) {
                hideQuestions(laData.logic[j].depQuestions);
            }
        }
    }
}

function displayQuestions(questions) {
    for (var j = 0; j < questions.length; j++) {
        showQuestion(questions[j]);
        /*re-evaluate the shown question*/
        reEvaluateById(questions[j]);
    }
}

function showQuestion(qID) {
    show(laFormData.questionRowPrefix + qID);
    show(laFormData.answerRowPrefix + qID);
}

function hideQuestion(qID) {
    hide(laFormData.questionRowPrefix + qID);
    hide(laFormData.answerRowPrefix + qID);
}

function show(tRowId) {
    var d1 = document.getElementById(tRowId);
    if (d1) {
        if (document.all) {
            d1.style.display = 'block';
        } else {
            d1.style.display = 'table-row';
        }
    }
}

function hide(tRowId) {
    var d1 = document.getElementById(tRowId);
    if (d1) {
        if(_removeBeforeSubmit){
            d1.parentNode.removeChild(d1);
        } else {
            d1.style.display="none";
        }
    }
}

if (window.attachEvent) 
    window.attachEvent('onload',applyLogic);
else
    window.addEventListener('load',applyLogic,false);
