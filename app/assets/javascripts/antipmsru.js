/**
 * Created by grador on 27.03.15.
 */
'use strict';
var aPms;

aPms = angular.module('aPms',['ui.router','templates','flow','ui.bootstrap','Devise']);

aPms.config(['$stateProvider', '$urlRouterProvider','$locationProvider', '$httpProvider',function($stateProvider, $urlRouterProvider,$locationProvider, $httpProvider) {
    $stateProvider.state('/', {
        url: '/',
        templateUrl: 'pagesIndex.html',
        controller: 'PagesIndexCtrl'
    });

    $stateProvider.state('settings', {
        url: '/pages',
        templateUrl: 'settings.html',
        controller: 'SettingsCtrl'
    });

    $stateProvider.state('friends', {
        url: '/friends',
        templateUrl: 'friendsIndex.html',
        controller: 'FriendsIndexCtrl'
    });

    $stateProvider.state('login', {
        url: '/login',
        templateUrl: 'login.html',
        controller: 'AuthCtrl',
        onEnter: ['$state', 'Auth', function($state, Auth) {
            Auth.currentUser().then(function (){
                $state.go('friends');
            })
        }]
    });

    $stateProvider.state('register', {
        url: '/register',
        templateUrl: 'register.html',
        controller: 'AuthCtrl',
        onEnter: ['$state', 'Auth', function($state, Auth) {
            Auth.currentUser().then(function (){
                $state.go('/');
            })
        }]
    });

    $urlRouterProvider.otherwise('/');

    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false
    });
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}])
.config(['flowFactoryProvider',function (flowFactoryProvider){
        flowFactoryProvider.defaults = {
            target: '/images',
            permanentErrors:[404, 422, 500, 501],
            maxChunkRetries: 1,
            chunkRetryInterval: 5000,
            minFileSize: 0,
            singleFile: true,
            testChunks: false,
            generateUniqueIdentifier: true
        }
}]);
