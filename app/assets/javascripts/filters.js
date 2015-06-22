/**
 * Created by grador on 31.03.15.
 */
// id - int
aPms.filter('findOne', function () {
    return function (items, id) {
        if(items) {
            if (Array.isArray(items)) {
                for (var i = 0; i < items.length; i++) {
                    if (items[i].id === id) {
                        return items[i];
                    }
                }
                return null;
            }
            return items.id === id ? items : null;
        }
        return null;
    };
})
// id - int
.filter('findMany', function () {
    return function (items, id) {
        if(items) {
            if (Array.isArray(items)) {
                var filtered = [];
                for (var i = 0; i < items.length; i++) {
                    if (items[i].id === id) {
                        filtered.push(items[i]);
                    }
                }
                return filtered;
            }
            return items.id === id ? items : null;
        }
        return null;
    };
})
.filter('findManyBy', function () {
    return function (items, prop, id) {
        if(items && prop) {
            if (Array.isArray(items)) {
                var filtered = [];
                for (var i = 0; i < items.length; i++) {
                    if (prop in items[i] && items[i][prop] === id) {
                        filtered.push(items[i]);
                    }
                }
                return filtered;
            }
            return prop in items && items[prop] === id ? items : null;
        }
        return null;
    };
})
// id - int
// prop - str
.filter('findOneBy', function () {
    return function (items, prop, id) {
        if(items && prop) {
            if(Array.isArray(items)) {
                for (var i = 0; i < items.length; i++) {
                    if ( prop in items[i] && items[i][prop] === id) {
                        return items[i];
                    }
                }
                return null;
            }
            return prop in items && items[prop] === id ? items : null;
        }
        return null;
    };
})
.filter('getLength', function () {
    return function (items) {
        return Array.isArray(items) ? items.length : null;
    };
})
.filter('active', function() {
    return function(arr) {
        return arr.filter(function(num){
            return num.status != 21 && num.status != 22;
        });
    };
})
.filter('lang', function() {
    return function(arr,lang) {
        return arr.filter(function(num){
            return num.language === lang || !num.language;
        });
    };
})
.filter('ifEmpty', function() {
    return function(prop,str) {
        return !!prop||prop===0||prop==='0'? prop : str;
    };
})
.filter('days', function() {
    return function(prop) {
        switch (prop){
            case 1:
            case 21:
            case 31:
            case 41:
                prop = prop +' день';
                break;
            case 2:
            case 3:
            case 4:
            case 22:
            case 23:
            case 24:
            case 32:
            case 33:
            case 34:
            case 42:
                prop = prop + ' дня';
                break;
            default :
                prop = prop + ' дней';
        }
        return prop;
    };
})
// id - int
// prop - str
.filter('getField', function () {
    return function (item, prop) {
        if(item && prop){
            if(Array.isArray(item)) {
                return prop in item[0] ? item[0][prop] : null;
            }
            return prop in item ? item[prop] : null;
        }
        return null;
    };
});