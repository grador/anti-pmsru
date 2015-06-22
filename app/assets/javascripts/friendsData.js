aPms.factory('friendsData', ['$http', '$q', function($http, $q)
{
    return {
        //вариант с обещанием
        // вызов:
        //friendsData.loadFriends().then(function(data){
        //    $scope.data = data;
        //});
        //---------------------------
        loadFriends: function () {
            var deferred = $q.defer();
            $http.get('/friends.json')
                .success(function (data) { deferred.resolve(data);})
                .error(function () { deferred.reject();});
            return deferred.promise;
        },
        //вариант с обратным вызовом
        //loadFriends: function (callback) {
        //    $http.get('/friends.json').success(callback);
        //},
        //Вызов:
        //friendsData.newFriends(function(data) {
        //    $scope.data = data;
        //});
        //---------------------------

        sendMail: function (url) {
            $http.get(url)
                .success(function(id){
                    var str = url.match('letters')? 'Письмо отправлено' : 'Письма отправлены';
                    alert(str +' на указанный Вами адрес.');
                    return id;
                })
                .error(function(id){
                    alert('Проблема с отправкой писем на указанный Вами адрес.');
                    return id;
                });
        },

        // post, put, delete

        sendChanges: function(url,method,data){
            if(!url || !method ){
                alert('Некорректные данные, повторите ввод!');
                return false;
            }
            $http({
                url: url +'.json',
                method: method.toUpperCase(),
                data: data
            })
            .success(function(id){ data.id = method==='POST'&&!!id? id:data.id; return id;})
            .error(function(id) {
                    alert('Что-то пошло не так! Отмените пару действий, нажмите кнопку обновить и повторите ввод.');
                    return id;});
        }
    }
}]);
