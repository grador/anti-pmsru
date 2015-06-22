/**
 * Created by grador on 23.05.15.
 */
aPms.controller('SettingsCtrl',[ '$scope', '$state', '$http','Auth', function($scope, $state,$http,Auth)
{
    $scope.user={};
    $scope.user1={};
    $scope.buf2='Премиум аккаунт';
    $scope.buf1='Бесплатный аккаунт';
    $scope.pass = '';
    $scope.collapsedPass = true;
    $scope.collapsedPayment = true;
    $scope.setDisabled = true;

    $scope.resetUser = {
        id: '',
        password:'',
        password_confirmation:''
    };

    Auth.currentUser().then(function (user){
        $scope.user = user;
        $scope.user1 = $scope.copyProp(user)
    }, function(){
        alert('Что-то пошло не так! Войдите в свой кабинет.');
        $state.go('login');
    });

    $scope.copyProp = function(from,target) {
        var copy = {};
        for (var key in from) {
            if(key[0]==='$'||Array.isArray(from[key])||typeof from[key]==='object')
                continue;
            if(target!=undefined && target.hasOwnProperty(key))
                target[key] = from[key];
            else
                copy[key] = from[key];
        }
        return !!target? target: copy;
    };

    $scope.toFriends = function() {
        $state.go('friends');
    };

    $scope.goToUpdate = function(){
        var buf ={};
        var empty = true;
        $scope.setDisabled = true;
        for (var key in $scope.user1) {
            if( $scope.user[key] != $scope.user1[key]){
                buf[key] = $scope.user[key];
                empty = false;
            }
        }
        if(empty) {
            alert('Ничего не изменено.');
            return true;
        }
        buf['id'] = $scope.user.id;
        $http({url:'/pages/'+$scope.user.id+'.json',method:'PUT',data: buf})
        .success(function(id){
            if(id>0){
                alert('Данные успешно изменены!');
                return true;
            } else if(id===0){
                alert('Для этого аккаунта нельзя менять данные!');
                $scope.user = $scope.copyProp($scope.user1,$scope.user);
                return true;
            }else{
                alert('Изменение данных отменено - проблемы с аккаунтом!');
                $scope.user = $scope.copyProp($scope.user1,$scope.user);
                return true;
            }
        })
        .error(function(){
            alert('Что-то пошло не так! Повторите ввод.');
            $scope.user = $scope.copyProp($scope.user1,$scope.user);
            return false;
        });

    };

    $scope.clearAll= function(){
        $scope.resetUser.password_confirmation='';
        $scope.pass='';
        $scope.resetUser.password='';
    };

    $scope.goToChangePass = function(){
        if($scope.resetUser.password_confirmation!=$scope.pass){
            alert('Не совпадают новый пароль и его повтор!');
            $scope.clearAll();
            return false;
        }
        if($scope.resetUser.password_confirmation===$scope.resetUser.password){
            alert('Действующий и новый пароли должны отличаться!');
            $scope.clearAll();
            return false;
        }
        $scope.collapsedPass = true;
        $scope.resetUser.id = $scope.user.id;
        $http({url:'/page.json',method:'PUT',data: $scope.resetUser})
        .success(function(id){
            if(id>0){
                alert('Пароль изменен - необходимо зайти в кабинет с новым паролем.');
                Auth.logout();
                $state.go('/');
            } else if(id===0){
                alert('Для этого аккаунта нельзя менять пароль!');
                $scope.clearAll();
                return true;
            }else{
                alert('Изменение пароля отменено, введен неверный действующий пароль!');
                $scope.clearAll();
                return true;
            }
            return true;
        })
        .error(function(){
            alert('Что-то пошло не так! Повторите ввод.');
            $scope.clearAll();
            return false;
        });

    };

    $scope.goToPayment = function(){
        $scope.setDisabled = true;
        $scope.collapsedPayment = true;

    };
    $scope.cancelEdit = function(){
        $scope.user = $scope.copyProp($scope.user1,$scope.user);
        $scope.setDisabled = true;
    };

}]);
