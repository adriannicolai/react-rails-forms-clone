$(document).ready(function(){
    $(document)
        .on("submit", "#submit_new_user", submit_new_user)
        .on("click", ".update_user", submit_update_user_form);
});

function submit_new_user(e){
    e.preventDefault();
    e.stopImmediatePropagation();

    let new_user_form = $(this);

    $.post(new_user_form.attr("action"), new_user_form.serialize(), function(new_user_data){
        if(new_user_data.status){
            let user_list = $("#user_list");
    
            user_list.append(new_user_data.html);
        }

        new_user_form.trigger("reset");
    });
}

function submit_update_user_form(e){
    e.stopImmediatePropagation();

    console.log("ca,e here");
    let update_button    = $(this);
    let update_user_form = $("#update_user_form");
    let update_user_details = update_button.closest(".user_details");

    /* Set the data needed by the backend */
    update_user_form.find(".user_id").val(update_user_details.find(".user_id").first().val());
    update_user_form.find(".first_name").val(update_user_details.find(".first_name").first().val());
    update_user_form.find(".last_name").val(update_user_details.find(".last_name").first().val());
    update_user_form.find(".email").val(update_user_details.find(".email").first().val());

    $.post(update_user_form.attr("action"), update_user_form.serialize(), function(update_user_result){
        console.log(update_user_result);
    });
}