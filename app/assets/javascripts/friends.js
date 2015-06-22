/**
 * Created by grador on 27.03.15.
 */
//status
//0  nothing
//1     -	new
//2     -   new saved
//9     -   returned
//10    - 	edit
//11    -   edited
//12    -   edited saved
//20    -   block
//21    -   blocked
//22    -   blocked saved
//30    -   delete
//31    -   deleted
//32    -   deleted saved
//100   -   admin
//101   -   paid

aPms.controller('FriendsIndexCtrl',[ '$scope', '$state', '$modal', 'friendsData','Auth', function($scope, $state,$modal, friendsData,Auth)
{
    $scope.loadtext = 'Загрузка данных...';
    friendsData.loadFriends().then(function(data){
        $scope.data = data;
        $scope.loadtext = false;
        $scope.data.friends.forEach(function(friend){
            friend.show = false;
        });
        $scope.data.agents.unshift({id:0, user:0, name: $scope.data.user.name, email: $scope.data.user.email, status:0, language:$scope.data.language});
    }, function () {
        $scope.loadtext = 'Нет ответа от сервера!';
    });

    $scope.cycles = [20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42];
    $scope.massPeriods = [
        { id:'cycle', name:'Цикл'},
        { id: 'year', name: 'Год'},
        { id: 'month', name:'Месяц'},
        { id: 'week', name:'Неделя'}];
    $scope.shifts = [0,1,2,3,4,5,6,7,8,9,10];
    $scope.show = false;
    //$scope.editLetter = false;
    $scope.symbol = false;
    $scope.intId = -1;
    $scope.edited = [];
    $scope.buffInput = null;
    $scope.flowData = {
            flow: new Flow(),
            msg: ''
    };

    $scope.Friend = function(){
        var i = $scope.putIntId();
        return {
            user_id: $scope.data.user.id,
            id: i,
            name:'',
            img:'',
            cycle_day:28,
            status: 1,
            gender:true,
            show: true,
            events:[]
        };
    };

    //$scope.isEditLetter = function(){
    //    return $scope.editLetter;
    //};
    //$scope.closeLetter = function(event){
    //    $scope.editLetter = false;
    //    event.stopPropagation();
    //};
    //
    //
    //$scope.toggleLetter = function(event){
    //    $scope.editLetter = !$scope.editLetter;
    //    event.stopPropagation();
    //};

    $scope.Event = function(friend){
        var i = $scope.putIntId();
        return {
            user: $scope.data.user.id,
            id: i,
            friend_id: friend.id||0,
            reason_id: 1,
            begin_date:$scope.dtToString($scope.toNow()),
            period: 'year',
            duration_day:1,
            shift_day: 1,
            color:friend.cycle_day||28,
            status:1,
            letters:[]
        }
    };

    $scope.Letter = function(event){
        return {
            user: $scope.data.user.id,
            id: $scope.putIntId(),
            event_id: event.id||0,
            agent: 0,
            from_id: 1,
            message_id: 1,
            status: 1
        };
    };

    $scope.getById = function(from,id){
        if(Array.isArray(from)) {
            for (i = 0; i < from.length; i++) {
                if (id === from[i].id)
                    return from[i];
            }
        }else if(from.hasOwnProperty('id')&&from.id===id)
            return from;
        return null;
    };

    $scope.getByElem = function(arr, elem){
        elem = Array.isArray(elem)? elem[0]:elem;
        if(elem.hasOwnProperty('item')){
            if(elem.status/10 === 3)
                return elem.item;
            else
                return Array.isArray(arr)? arr.filter(function(num){return num.id === elem.item.id})[0]: null;
        }else
            return Array.isArray(arr)? arr.filter(function(num){return num.id === elem.id})[0]: null;
    };

    $scope.newFriend = function(){
        if($scope.isNotPaid() && $scope.data.friends.length>0){
            alert('Ограничение беплатного аккаунта! Не более одного объекта для наблюдения. Для снятия ограничения переходите на премиальный аккаунт.');
            $scope.data.friends[0].show = true;
        }else{
            var i = $scope.data.friends.push($scope.Friend())-1;
            $scope.saveCondition('friends', $scope.data.friends[i],i,2);
            $scope.saveChanges('friends',$scope.data.friends[i],1);
        }
    };

    $scope.newEvent = function(friend){
        if($scope.isNotPaid() && friend.events.length>1)
            alert('Ограничение беплатного аккаунта! Не более двух событий для наблюдения. Для снятия ограничения переходите на премиальный аккаунт.');
        else {
            var i = friend.events.push($scope.Event(friend)) - 1;
            $scope.saveCondition('events', friend.events[i], i, 2);
            $scope.saveChanges('events', friend.events[i], 1);
        }
    };

    $scope.newLetter = function(event){
        if($scope.isNotPaid() && event.letters.length>0)
            alert('Ограничение беплатного аккаунта! Не более одного адреса рассылки для события. Для снятия ограничения переходите на премиальный аккаунт.');
        else {
            var i = event.letters.push($scope.Letter(event)) - 1;
            $scope.saveCondition('letters', event.letters[i], i, 2, event);
            $scope.saveChanges('letters', event.letters[i], 1);
        }
    };
    $scope.isNotPaid = function(){
        return !$scope.data.user.paid || $scope.data.user.paid<$scope.toNow();
    };
    $scope.isSomeLetter = function(item) {
        if(Array.isArray(item))
            item = item[0];
        if( item.hasOwnProperty('letters')) //item is event
            return !!item.letters.length;
        else if(item.hasOwnProperty('events')) //item is friend
            return item.events.some(function(event){ return !!event.letters.length});
        else if(item.hasOwnProperty('friends')) //item is data
            return false;
        return true;  // item is letter
    };

    $scope.delElem = function(table,mass,elem){
        var item;
        if(confirm('Удалить? Вы уверены?\nУдаление можно будет отменить и вернуть удаленный элемент.')){
            if( mass.hasOwnProperty(table)&&Array.isArray(mass[table])){
                var ind = mass[table].indexOf(elem);
                item = mass[table].splice(ind,1)[0];
                $scope.saveCondition(table,item,ind,32,mass);
                $scope.saveChanges(table,item,31);
                return $scope.edited.length;
            }else if(mass.hasOwnProperty(table)&&mass[table] === elem){
                $scope.saveCondition(table,mass[table],0,32,mass);
                $scope.saveChanges(table,mass[table],31);
                mass[table] = null;
                return $scope.edited.length;
            }
        }
        return null;
    };
    //TODO доделать в селект контроллере ввод старого значения при откате
    $scope.showOldData = function(target,prop){
        target[prop] = $scope.last($scope.edited).item[prop];
    };

    $scope.saveCondition = function(nameTable, item, nameProp, status,idf){
        var i=null;
        if(!!idf){
            i=Array.isArray(idf)?idf[0]:idf;
            i= i.hasOwnProperty('friend_id')? i.friend_id:null;
        }
        $scope.edited.push({tab: nameTable, item: $scope.clone(item), prop: nameProp, status: status||1, idf:i});
    };

    $scope.reWindAll = function(){
        while(!!$scope.edited.length)
            $scope.reWind();
    };

    $scope.showRewindButton = function(tabName,item,prop){
        var lastEd = $scope.last($scope.edited);
        if(!!prop)
            return !!$scope.edited.length && lastEd.prop === prop && lastEd.item.id === item.id;
        else if(!!item)
            return !!$scope.edited.length && lastEd.tab === tabName && lastEd.item.id === item.id  && lastEd.status != 1;
        else if(!!tabName)
            return !!$scope.edited.length && lastEd.tab === tabName && lastEd.status != 1;
        else
            return !!$scope.edited.length;
    };

    $scope.cleanEdited = function(){
      $scope.edited = [];
    };

    $scope.reWind = function(item,field) {
        var lastEd = $scope.last($scope.edited);
        if(!!field && !!item && item.hasOwnProperty(field) && lastEd.prop === field && lastEd.item.id === item.id) {
            // откат по конкретным объекту и полю
            item[field] = lastEd.item[field];
        }else if(!!item && lastEd.item.id === item.id && item.hasOwnProperty(lastEd.prop)) {
            // откат по конкретному объекту
            item = $scope.goBack(item);
        }else if($scope.data.hasOwnProperty(lastEd.tab)){
            // откат все подряд на верхнем уровне
            // поиск 1 уровня $scope.data
            item = $scope.goBack($scope.data[lastEd.tab]);
        }else if($scope.data.friends[0].hasOwnProperty(lastEd.tab)){
            // 2nd level find
                item = $scope.getById($scope.data.friends,lastEd.item.friend_id);
                if(item)
                   item = $scope.goBack(item.events);
        }else if($scope.data.friends[0].events[0].hasOwnProperty(lastEd.tab)){
            // 3th level find
            item = $scope.getById($scope.data.friends,lastEd.idf);
            if(item) {
                item = $scope.getById(item.events, lastEd.item.event_id);
                if(item)
                    item = $scope.goBack(item.letters);
            }
        }else
            return null;
        $scope.saveChanges(lastEd.tab,item,lastEd.status);
        $scope.edited.pop();
        return item;
    };

    $scope.goBack = function(arr) {
        var lastEd = $scope.last($scope.edited);
        var item;
        switch (lastEd.status){
            case 12: //saved Edited
            case 22:// saved Blocked
            case 9: //Rewinded
                item = $scope.getById(arr,lastEd.item.id);
                //$scope.copyPropInObject(lastEd.item,item);
                item[lastEd.prop] = lastEd.item[lastEd.prop];
                if(lastEd.prop === 'reason_id')
                    item.period = lastEd.item.period;
                break;
            case 32:// saved Deleted empty
                arr.splice(lastEd.prop,0,lastEd.item);
                item = $scope.clone(lastEd.item);
                break;
            case 2: //saved New
                item = arr.splice(lastEd.prop,1)[0];
                break;
            default :
                return null;
        }
        return item;
    };

    $scope.isDemo = function(){
        return ($scope.user.id <6);
    };

    $scope.isBanned = function(){
        return (!!$scope.data.banned);
    };

    $scope.saveChanges = function(tabName,item,status){
        var url='/'+tabName;
        var method = '';
        var data ='';
        if(item.id<=0)
            item.id = '';
        switch (status){
            case 1: // new - POST
                item.status = 0;
                method = 'POST';
                data = item;
                break;
            case 32:
                item.show = 'blocked';
            case 9:
            case 11:
            case 12:
            case 22:
                method = 'PUT';
                item.status = 0;
                url = url+'/'+item.id;
                data = item;
                break;
            case 31:
                item.show = 'blocked';
            case 21:
                method = 'PUT';
                item.status = status+1;
                url = url+'/'+item.id;
                data = item;
                break;
            case 2:
                method = 'DELETE';
                url = url+'/'+item.id;
                break;
            case 0:
            case 10:
            case 20:
            case 30:
            default :
                return null;
        }
        //TODO отключить для ввода демо
        if(!$scope.isDemo())
            friendsData.sendChanges(url,method,data);
    };

    $scope.sentMail = function(tabName,item){
        if($scope.isDemo()){
            alert('Отправка писем в демо режиме отключена! Пройдите регистрацию и мы отправим сообщения на Ваш адрес!');
            return true;
        }
        if($scope.isBanned()){
            alert('Отправка писем отключена, т.к. Вы заблокированы. О причинах читайте сообщение в Вашей почте.');
            return true;
        }
        friendsData.sendMail('/'+tabName+'/'+item.id+'.json');
    };
    $scope.saveImg = function(friend){
        $scope.flowData.flow.files = [];
        $scope.saveCondition('friends',friend,'img',12);
        friend.img = $scope.flowData.msg;
        $scope.saveChanges('friends',friend,11);
        $scope.flowData.msg = '';
    };
    $scope.delImg = function(){
        $scope.flowData.flow.files = [];
        $scope.flowData.msg = '';
    };

    // verb - str: действие(ad, edit, del;
    // name - str: имя справочника (reasons,messages,froms, agents)
    // size - str: размер окна(md(null), lg, sm).
    $scope.openModal = function (verb,name,size) {
        verb = verb.toLowerCase();
        name = name.toLowerCase();
        if( name === 'agents' && verb ==='add'){
            if(!confirm('Ввод нового адреса получателя требует подтвержения доступа к нему. На этот адрес будет отправлено сообщение. Продолжить?'))
               return null;
        }
        if($scope.data.hasOwnProperty(name)){
            var oldItems;
            var oldVal;
            var camelCaseStr = verb[0].toUpperCase()+verb.slice(1)+name[0].toUpperCase()+name.slice(1);
            if(verb !='add')
                oldItems = $scope.clone($scope.data[name]);
            var modalInstance = $modal.open({
                templateUrl: 'modal'+camelCaseStr+'.html',
                controller: 'ModalCtrl',
                size: size,
                resolve:{
                    data: function () {
                        return $scope.data[name];
                    },
                    language: function () {
                        return $scope.data.language;
                    }
                }
            });

            modalInstance.result.then(function (selectedItem) {
                if(Array.isArray(selectedItem) && verb!='add'){
                    selectedItem.forEach(function(item){
                        oldVal = $scope.getByElem(oldItems,item);
                        switch (item.status){
                            case 10: // edited восстановить прежнее значение
                                $scope.data[name][$scope.data[name].indexOf(item)] = $scope.clone(oldVal);
                                break;
                            case 20:
                                item.status = 21;
                            case 21:
                                if(item.status != oldVal.status){
                                    $scope.saveCondition(name, oldVal, 'status',22);
                                    if(name!='agents'||item.id!=0)
                                        $scope.saveChanges(name,item,21);
                                }
                                break;
                            case 9:
                                if(item.status != oldVal.status&&item.id!=0){
                                    $scope.saveCondition(name, oldVal, 'status',9);
                                    $scope.saveChanges(name,item,9);
                                }
                                break;
                            case 11: // saved after edited
                                for (var prop in item){
                                    if(prop!='status' && prop[0]!='$' && oldVal[prop]!=item[prop]){
                                        $scope.saveCondition(name, oldVal, prop,12);
                                        $scope.saveChanges(name,item,11);
                                        break;
                                    }
                                }
                                break;
                            default:
                        }
                    });
                }else{
                    if(selectedItem.status===1 && verb==='add'){
                        selectedItem.user = $scope.data.user.id;
                        selectedItem.id = $scope.putIntId();
                        selectedItem.language = null;
                        for(var key in selectedItem){
                            if(!selectedItem[key])
                                delete selectedItem[key];
                        }
                        if(name === 'agents') {
                            //selectedItem.status = 5;
                            $scope.saveChanges(name, selectedItem, 1);
                        }else {
                            var ii = $scope.data[name].push(selectedItem) - 1;
                            $scope.saveCondition(name, $scope.data[name][ii], ii, 2);
                            $scope.saveChanges(name, $scope.data[name][ii], 1);
                        }
                    }
                }
            }, function(){
                $scope.data[name] = $scope.clone(oldItems);
            });
        }
    };

    $scope.putIntId = function(){
        return $scope.intId--;
    };

    $scope.putId = function(id){
        return id||$scope.intId--;
    };

    $scope.toNow = function(){
        return new Date();
    };


    $scope.inputController = function(verb,item,prop,type,table,status,parent){
        switch (verb){
            case 'focus':
                $scope.buffInput = $scope.clone(item);
                break;
            case 'blur':
                if($scope.buffInput[prop]!= item[prop]){
                    if($scope.isValidVal(item[prop],type)){
                        $scope.saveCondition(table, $scope.buffInput, prop, status+1,parent);
                        $scope.saveChanges(table,item,status);
                    }
                    else
                        item[prop] = $scope.buffInput[prop];
                }
                $scope.buffInput = null;
        }
        return item[prop];
    };

    //$scope.cycleController = function(verb,tab,cycle){
    //    if(verb === 'focus'){
    //        if(tab.cycle_day != cycle){
    //            if($scope.edited.length===0||$scope.last($scope.edited).prop!='cycle_day')
    //                $scope.saveCondition('friends',tab,'cycle_day',12);
    //            tab.cycle_day = cycle;
    //        }
    //    }else if(verb === 'blur'){
            //tab.cycle_day = cycle;
            //console.log('blur');
            //$scope.saveChanges('friends',tab,11);

        //}
    //};

    $scope.digitController = function(verb,tab,prop,val,nameTable,status,parent){
        switch (verb){
            case 'focus':
                $scope.buffInput = $scope.clone(tab);
                break;
            case 'blur' :
                val = val||val===0? val:tab[prop];
                if($scope.buffInput[prop] != val){
                    $scope.saveCondition(nameTable,$scope.buffInput,prop,status+1,parent);
                    tab[prop] = val;
                    $scope.saveChanges(nameTable,tab,status);
                }
                break;
            case 'click':
                val = val||val===0? val:tab[prop];
                tab[prop] = val;
        }
        return tab[prop];
    };

    $scope.selectController = function(verb,target,newItem,nameTable,prop,status,parent){
        function toTarget(){
            target[prop] = newItem.id;
            if(nameTable == 'events'){
                target.period = newItem.period;
                target.duration_day = newItem.duration_day;
            }
        }
        switch (verb){
            case 'focus':
                $scope.buffInput = $scope.clone(target);
                break;
            case 'click':
                //parent.stopPropagation();
                if(newItem)
                    toTarget();
                break;
            case 'blur':
                if(newItem && $scope.buffInput[prop]!=newItem.id){
                    toTarget();
                    $scope.saveCondition(nameTable, $scope.buffInput, prop,status+1,parent);
                    $scope.saveChanges(nameTable,target,status);
                }
                $scope.buffInput = null;
        }
        return target;
    };

    $scope.calculateDate = function(event,friend){
        if(event.period === 'cycle'){
            var ev;
            var list = friend.events.filter(function(item){ return item.period ==='cycle'&&item.id!= event.id});
            if(list.length > 0){
                ev = list.filter(function(item){ return item.reason_id===3});
                return $scope.dateEventCalculator(event, ev.length>0 ? ev : list, friend);
            }else {
                alert('Для данного объекта наблюдения не было определено ни одного события связанного с циклом!');
            }
        }else {
            alert('Данное событие не связано с циклом - нечего расчитывать!');
            return $scope.toNow();
        }
    };

    $scope.date_add_days = function(date, days){
        if(!(date instanceof Date))
            date = new Date(date);
        return new Date(date.getTime() + days * 24 * 60 * 60 * 1000);
    };

    //$scope.dtToString = function(dt){
    //    return dt instanceof Date ? [dt.getDate(), dt.getMonth()+1, dt.getFullYear()].join('-'): dt;
    //};
    $scope.dtToString = function(dt){
        if(dt instanceof Date){
            var d = dt.toLocaleDateString();
            return d.substring(6,10) + '-' + d.substring(3,5) + '-' + d.substring(0,2);
        }
        return null;
    };



    $scope.dateEventCalculator = function(evto,evfrom,friend){
        var days,str = 'case';
        if(!evto||!evfrom||!friend)
            return $scope.toNow();
        if(Array.isArray(evto))
            evto = evto[0];
        if(Array.isArray(evfrom))
            evfrom = evfrom[0];
        if(Array.isArray(friend))
            friend = friend[0];
        str = str+(evto.reason_id>6? evto.reason_id-6 : evto.reason_id) + (evfrom.reason_id>6? evfrom.reason_id-6 : evfrom.reason_id);
        switch (str){
            case 'case43':
            case 'case53':
                //Leak-3+cycle/2
            case 'case34':
            case 'case35':
                //ovulate-3+cycle/2
                days = friend.cycle_day/2-3;
                break;
            case 'case23':
            case 'case63':
                //leak+cycle-3
                days = friend.cycle_day -3;
                break;
            case 'case32':
            case 'case36':
                //pms+3
                days = 3;
                break;
            case 'case24':
            case 'case64':
            case 'case25':
            case 'case65':
                //ovulate+cycle/2
            case 'case42':
            case 'case52':
            case 'case46':
            case 'case56':
                //pms+cycle/2
                days = friend.cycle_day/2;
                break;
            case 'case22':
            case 'case26':
            case 'case33':
            case 'case44':
            case 'case55':
            case 'case45':
            case 'case54':
            case 'case66':
            case 'case62':
                days = friend.cycle_day;
                break;
            case 'case11':
                days = 0;
                break;
            default:
                return $scope.toNow();
        }
        str = $scope.date_add_days(evfrom.begin_date,days);
        while(!$scope.isActualDate(str,friend.cycle_day)){
            if(str> new Date())
                days = -friend.cycle_day;
            else
                days = friend.cycle_day;
            str = $scope.date_add_days(str,days);
        }
        return str;
    };

    $scope.isActualDate = function(date,cycle_day){
        if(date instanceof Date){
            if(!!cycle_day)
                return date>$scope.date_add_days(new Date(),-cycle_day) && date<$scope.date_add_days(new Date(),cycle_day);
            return true;
        }
        return false;
    };

    $scope.isActualDateEvent = function(event,friend){
        return $scope.isActualDate(event.begin_date,friend.cycle_day);
    };
    //TODO Кнопка актуализации даты
    $scope.dateController = function(event,dt){
        if(dt){
            $scope.toggleCalendar(false);
            if(event.begin_date!=$scope.dtToString(dt)){
                $scope.saveCondition('events', event, 'begin_date', 12);
                event.begin_date = $scope.dtToString(dt);
                $scope.saveChanges('events',event,11);
            }
        }
    };

    $scope.isValidVal = function(val,type){
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        if(type == 'email')
            return emailPattern.test(val);
        return val? true: false;
    };

    $scope.last = function(arr){
        return Array.isArray(arr)? arr[arr.length-1]:arr;
    };

    $scope.toggleCalendar = function(flag){
        $scope.show = flag===undefined? !$scope.show: !!flag;
    };

    $scope.copyPropInObject = function(from,target) {
        var copy = {};
        for (var key in from) {
            if(key[0]==='$'||key==='id'||key==='status'||Array.isArray(from[key])||typeof from[key]==='object')
                continue;
            if(!!target && target.hasOwnProperty(key))
                target[key] = from[key];
            else
                copy[key] = from[key];
        }
        return !!target? target: copy;
    };
    $scope.copyObject = function(obj) {
        var copy = {};
        for (var key in obj) {
            if(Array.isArray(obj[key]))
                copy[key]= $scope.copyArray(obj[key]);
            else if(obj[key]=== null || obj[key]=== undefined)
                copy[key] = null;
            else if(typeof obj[key]=='object')
                copy[key]= $scope.copyObject(obj[key]);
            else
                copy[key] = obj[key];
        }
        return copy;
    };

    $scope.copyArray = function(array){
        var copy = [];
        for (var i=0, l=array.length; i<l; i++) {
            if (!!array[i] && typeof array[i] == 'object')
                copy[i] = $scope.copyObject(array[i]);
            else if(Array.isArray(array[i]))
                copy[i] = $scope.copyArray(array[i]);
            else if(!!array[i])
                copy[i] = array[i];
            else
                copy[i]=null;
        }
        return copy;
    };

    $scope.clone = function(array){
        if(Array.isArray(array))
            return $scope.copyArray(array);
        else if(!!array && typeof array === 'object')
            return $scope.copyObject( array);
        return array;
    };

    $scope.toRoot = function() {
        $state.go('/');
    };
    $scope.toLogin = function() {
        $state.go('login');
    };

    $scope.toRegister = function() {
        Auth.logout().then(function(){
            $state.go('register')})
    };
    $scope.toSetting = function() {
        $state.go('settings');
    };
    $scope.toFriends = function() {
        $state.go('friends');
    };
    $scope.signedIn = Auth.isAuthenticated;
    $scope.logout = function(){
        Auth.logout().then(function(){
            $state.go('/')});
    };

    Auth.currentUser().then(function (user){
        $scope.user = user;
    });
    $scope.$on('devise:logout', function (e, user){
        $scope.user = {};
    });

}])
.controller('ModalCtrl',['$scope', '$modalInstance','data','language',function ($scope, $modalInstance,data,language) {
    $scope.items = data;
    $scope.language = language;
    $scope.newItem = {
        id: null,
        user: null,
        name: null,
        email: null,
        img: null,
        status: 0,
        theme: null,
        text: null,
        period: null,
        duration_day: null
    };
    $scope.buffer = null;
    $scope.collapsed = true;
    $scope.usageFlag = true;
    $scope.massPeriods = [
        { id:'cycle', name:'Цикл'},
        { id: 'year', name: 'Год'},
        { id: 'month', name:'Месяц'},
        { id: 'week', name:'Неделя'}];
    $scope.shifts = [0,1,2,3,4,5,6,7,8,9,10];

    $scope.toEdit = function(item){
        var flag = $scope.newItem && item.id == $scope.newItem.id ? undefined: false;
        $scope.usageFlag = false;
        $scope.newItem = item;
        $scope.isCollapsed(flag);
        item.status = 10;
    };

    $scope.toDel = function(item){
        item.status = item.status==20||item.status==21||item.status==22? 9:20;
    };

    $scope.isIt = function(item,stat1,stat2,stat3){
        return item.user!=0 && (item.status===stat1||item.status===stat2||item.status===stat3);
    };

    $scope.isCollapsed = function(flag){
        $scope.collapsed = flag===undefined ? !$scope.collapsed : flag;
    };

    $scope.testEmail = function(mail){
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        return emailPattern.test(mail);
    };

    $scope.addAgent = function(){
        alert('На указанный адрес отправлено письмо для подтверждения Вашего доступа к нему. До подтверждения адрес не доступен для работы.');
        return $scope.add();
    };

    $scope.add = function () {
        if(!$scope.newItem.email || $scope.testEmail($scope.newItem.email)){
            if(!$scope.newItem.status)
            {
                $scope.newItem.status = 1;
                $modalInstance.close($scope.newItem);
            }else $scope.localSave(11);
        }else{
            alert('Неверный формат адреса электронной почты!');
            return null;
        }
    };

    $scope.ok = function () {
        $modalInstance.close($scope.items);
    };

    $scope.localSave = function (flag) {
        $scope.newItem.status = flag;
        $scope.isCollapsed(true);
    };

    $scope.someIs = function(flag){
        return $scope.items.some(function(item){return item.status===flag;});
    };

    $scope.everyIs = function(flag){
        return $scope.items.every(function(item){return item.status===flag;});
    };

    $scope.cancel = function () {
        $scope.items.forEach(function(item){
            if(item.status%10===0)
                item.status=0;
        });
        $modalInstance.close($scope.items);
    };

    $scope.close = function () {
        if($scope.usageFlag)
            $scope.cancel();
        else
            $scope.localSave(10);
    };
    $scope.cancelHelp = function () {
        $modalInstance.dismiss('cancel');
    };
}]);