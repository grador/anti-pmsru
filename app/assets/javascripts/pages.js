/**
 * Created by grador on 27.03.15.
 */
aPms.controller('PagesIndexCtrl', [ '$scope','$state', 'friendsData','Auth', function($scope,$state,friendsData,Auth) {
    friendsData.loadPages().then(function(data){
        $scope.data = data;
        $scope.goodSlides = $scope.data.goodSlides;
        $scope.badSlides = $scope.data.badSlides;
    }, function () {
        $scope.loadtext = 'Нет ответа от сервера!';
    });
    $scope.user = {
        name:'',
        email: '',
        password: ''};
    $scope.myInterval = 4000;
    $scope.badColapse = true;
    $scope.goodColapse = true;
    $scope.changeColor = true;
    if(Auth.isAuthenticated){
        Auth.currentUser().then(function (user){
            $scope.user = user;
    })}

    $scope.toNow = function(){
        return new Date();
    };
    $scope.date_add_days = function(date, days){
        if(!(date instanceof Date))
            date = new Date(date);
        return new Date(date.getTime() + days * 24 * 60 * 60 * 1000);
    };
    $scope.toLogin = function() {
        $state.go('login');
    };
    $scope.toRegister = function() {
        Auth.logout().then(function(){
            $state.go('register')})
    };
    $scope.toFriends = function() {
        $state.go('friends');
    };
    $scope.goToInfo = function() {
        $state.go('/');
    };
    $scope.toSetting = function() {
        $state.go('settings');
    };
    $scope.toRoot = function() {
        $state.go('/');
    };

    $scope.isDemo = function(){
        return ($scope.user.id <6);
    };

    $scope.goToMaleDemo = function(){
        Auth.logout().then(function() {
            $scope.user.email = 'male@anti-pms.ru';
            $scope.user.password = '1111';
            $scope.demoLogin();
        });
    };

    $scope.goToFemaleDemo = function(){
        Auth.logout().then(function() {
            $scope.user.email = 'female@anti-pms.ru';
            $scope.user.password = '1111';
            $scope.demoLogin();
        });
    };

    $scope.demoLogin = function(){
        Auth.login($scope.user).then(function(){
            $scope.toFriends();
        },function(){
            $scope.toRoot();
        });

    };
    $scope.signedIn = Auth.isAuthenticated;
    $scope.logout = function(){
        Auth.logout().then(function(){
            $state.go('/')});
    };

    $scope.$on('devise:new-registration', function (e, user){
        $scope.user = user;
    });

    $scope.$on('devise:login', function (e, user){
        $scope.user = user;
    });

    $scope.$on('devise:logout', function (e, user){
        $scope.user = {};
    });
}])
.controller('AuthCtrl', ['$scope','$state','$http','Auth', function($scope, $state, $http, Auth){
    $scope.collapsed = true;
    $scope.data = { email:''};
    $scope.user = {
        email: '',
        password: ''};
    $scope.newUser = {
        name:'',
        email: '',
        password: '',
        password_confirmation: ''};

    $scope.$on('devise:new-registration', function (e, user){
        $scope.user = user;
    });

    $scope.$on('devise:login', function (e, user){
        $scope.user = user;
    });
    $scope.goToLogin = function() {
        Auth.login($scope.user).then(function(){
            $state.go('friends');
        },function(){
            $state.go('/');
        });
    };

    $scope.goToResetPass = function() {
        if(!$scope.testEmail($scope.user.email)||!$scope.testEmail($scope.data.email)){
            alert('Некорректно введен E-mail!');
            return false;
        }
        if($scope.user.email != $scope.data.email){
            alert('Не совпадают два введенных адреса E-mail!');
            return false;
        }
        $scope.collapsed =!$scope.collapsed;
        $http({url:'/pages.json',method:'POST',data:$scope.data})
            .success(function(id){
                if(id>0){
                    alert('Инструкции отправлены на Ваш E-mail.');
                    $state.go('/');
                }
                else if(id<0) {
                    alert('Не мудрите с адресом! Проверьте введенный E-mail.');
                    $state.go('login');
                }
                else if(id===0) {
                    alert('Нет такого пользователя! Проверьте введенный E-mail.');
                    $state.go('login');
                }
            })
            .error(function(id) {
                if(id!=0)
                    alert('Что-то пошло не так! Попробуйте вспомнить E-mail и пароль или повторить отправку запроса на смену пароля.');
                $state.go('/');
            });
    };

    $scope.testEmail = function(mail){
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        return emailPattern.test(mail);
    };

    $scope.goToRoot = function() {
        $state.go('/');
    };

    $scope.goToRegister = function() {
        if(!$scope.testEmail($scope.newUser.email)){
            alert('Некорректно введен E-mail!');
            return false;
        }
        if($scope.newUser.password != $scope.newUser.password_confirmation){
            alert('Пароль и его повтор не совпадают!');
            $scope.newUser.password = '';
            $scope.newUser.password_confirmation = '';
            return false;
        }
        Auth.register($scope.newUser).then(function(){
            alert('Вы прошли регистрацию. На вашу почту отправлено письмо для подтверждения адреса. После подтверждения вы получите полный доступ к личному кабинету!');
            $state.go('friends');
        },function(){
            alert('Регистрация не пройдена! Возможно на Ваш E-mail уже зарегистрирован аккаунт. Смените E-mail или восстановите досуп к существующему аккаунту в разделе ВХОД-ЗАБЫЛИ ПАРОЛЬ.');
            return false;
        });
    };
}]);
