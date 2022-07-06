import React from 'react';
import ReactDOM from 'react-dom';
import {Provider} from 'react-redux';
import { configureStore } from '@reduxjs/toolkit'
import App from './components/app';
import reducers from './reducers';
import thunk from 'redux-thunk';

ReactDOM.render(
    <Provider store={configureStore({
        reducer: reducers,
        middlewares: [thunk]
    })}>
        <App />
    </Provider>,
    document.getElementById('root')
);