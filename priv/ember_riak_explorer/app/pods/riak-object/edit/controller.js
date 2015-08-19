import Ember from 'ember';

export default Ember.Controller.extend({
    explorer: Ember.inject.service('explorer'),

    actions: {
        saveObject: function(object) {
            this.get('explorer').saveObject(object);
            this.transitionToRoute('riak-object', object);
        }
    }
});