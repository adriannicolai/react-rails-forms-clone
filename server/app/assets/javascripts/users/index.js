$(document).ready(function(){
    $(document)
        .on("submit", "#submit_new_user", submit_new_user);
});

function submit_new_user(e){
    e.preventDefault();
    e.stopImmediatePropagation();

    let new_user_form = $(this);

    $.post(new_user_form.attr("action"), new_user_form.serialize(), function(data){
        console.log(data);
    });
}