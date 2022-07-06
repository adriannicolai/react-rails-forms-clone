import { combineReducers } from "redux";

const formsReducer = (state = [], action) => {
    return { testing: "user_test"};
}

const usersReducer = (state = [], action) => {
    switch(action.type){
        case 'REGISTER_USER':
            return {user: action.payload}
        default:
            return state
    }
}

export default combineReducers({
    forms: formsReducer,
    users: usersReducer
});