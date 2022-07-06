import React, {Component} from 'react';
import {connect} from 'react-redux';
import {forms} from '../actions'

class Forms extends Component {
    render(){
        return (<div>sadsa</div>)
    }
}

const mapStateToProps = (state) => {
    return { forms: state.forms }
}

export default connect(mapStateToProps, {forms})(Forms);