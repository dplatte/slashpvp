angular.module('app').controller('CharacterCtrl', ['$scope', '$http', '$timeout', function($scope, $http, $timeout) {
	
	$scope.init = function() {
		$scope.characters = [];
		$scope.filteredCharacters = [];
		$scope.limitVar = 150;
		$scope.beginVar = 0;
		$scope.limitStep = 50;
		$scope.query = "";
		$scope.sort = {
			orderVar: '',
			reverse: false
		};
		$scope.classFilter = {
			1: false,
			2: false,
			3: false,
			4: false,
			5: false,
			6: false,
			7: false,
			8: false,
			9: false,
			10: false,
			11: false
		}
		$scope.specFilter = {
			62: false,
			63: false,
			64: false,
			65: false,
			66: false,
			70: false,
			71: false,
			72: false,
			73: false,
			102: false,
			103: false,
			104: false,
			105: false,
			250: false,
			251: false,
			252: false,
			253: false,
			254: false,
			255: false,
			256: false,
			257: false,
			258: false,
			259: false,
			260: false,
			261: false,
			262: false,
			263: false,
			264: false,
			265: false,
			266: false,
			267: false,
			268: false,
			269: false,
			270: false
		}

		$scope.pages = [];
		$scope.pagination = {
			current: 1,
			last: 1,
			displayPages: 9,
			itemsPerPage: 50,
			container: '#ladderContent',
			itemContainer: 'tr'
		}

		$(window).trigger('resize');
	};

	var pageUpdateFlag = true;

	$scope.$watchCollection('filteredCharacters', function() {
		$scope.setCurrentPage(1);
		$('#ladderContent').scrollTop(0);
	});

	$scope.setCurrentPage = function(page) {
		$scope.updateCurrentPage(page);
		if(page == 1) {
			$scope.beginVar	= 0;
			$('#ladderContent').scrollTop(0)
		} else {
			$scope.beginVar	= page * $scope.pagination.itemsPerPage - $scope.pagination.itemsPerPage * 2;
			$('#ladderContent').scrollTop(48 * 51)
		}
	};

	$scope.updateCurrentPage = function(page) {
		$scope.pagination.last = Math.ceil($scope.filteredCharacters.length / $scope.pagination.itemsPerPage);

		$scope.pages = [];
		var endPage = page + 4;
		var startPage = page - 4;
		if($scope.pagination.last - startPage < 8) {
			startPage = $scope.pagination.last - 8;
		}
		for(var i = startPage; i <= endPage; i++) {
			if(i > 0 && i <= $scope.pagination.last) {
				$scope.pages.push(i);
			} else if(endPage < $scope.pagination.last) {
				endPage++;
			}
		}

		$scope.pagination.current = page;
	}

	$scope.customRecentCharacterFilter = function (c) {
	    var re = new RegExp($scope.query, 'i');

	    return ($scope.classFilter[c.character.character_class_id] || 
	    	noFilter($scope.classFilter)) &&
	    	re.test(c.character.name);
	};

	$scope.customCharacterFilter = function (character) {
	    var re = new RegExp($scope.query, 'i');

	    return ($scope.classFilter[character.character_class_id] || 
	    	noFilter($scope.classFilter)) &&
	    	re.test(character.name);
	};

	function noFilter(filterObj) {
	    for (var key in filterObj) {
	        if (filterObj[key]) {
	            return false;
	        }
	    }
	    return true;
	}
	
	$scope.getLadder = function(){
		$http.get(
			"/character/ladderJson"
		).success(function(data) {
			$scope.characters = data;
		});

	};

	$scope.getRecent = function(region, bracket){
		$http.get(
			"/character/recentJson", {}
		).success(function(data) {
			$scope.characters = data;
		});
		$timeout(function() {
			$scope.getRecent(region, bracket);
		}, 10000);
	};

	$scope.getCharacterHistory = function(c_id) {
		$http.get(
			"/match_history/characterJson", { 
				params: {
					character_id: c_id
				}
			}
		).success(function(data) {
			$scope.characters = data;
		});
	};

	$scope.showCharacterHistory = function(id) {
		window.location.href = '/characterHistory/' + id;
	};

	$scope.order = function(v) {
		$scope.sort.reverse = ($scope.sort.orderVar === v) ? !$scope.sort.reverse : false;
		$scope.sort.orderVar = v;
	};

	$scope.updateLowerLimits = function() {
		console.log('updating lower limits');
		pageUpdateFlag = false;
		var curScrollHeight = $('#ladderContent').scrollTop();
		console.log($scope.pagination);
		console.log($scope.beginVar);
		if($scope.pagination.current > 1) {
			$scope.beginVar += 50;
		} else {
			curScrollHeight += $($scope.pagination.container + ' ' + $scope.pagination.itemContainer).height() * $scope.pagination.itemsPerPage;
		}
		$scope.updateCurrentPage($scope.pagination.current + 1);
		$scope.$apply();

		$('#ladderContent').scrollTop(curScrollHeight - $($scope.pagination.container + ' ' + $scope.pagination.itemContainer).height() * $scope.pagination.itemsPerPage);

		pageUpdateFlag = true;
	};

	$scope.updateUpperLimits = function() {
		console.log('updating upper limits');
		var curScrollHeight = $('#ladderContent').scrollTop();
		pageUpdateFlag = false;
		$scope.updateCurrentPage($scope.pagination.current - 1);
		if($scope.pagination.current > 1) {
			$scope.beginVar -= 50;
		}
		$scope.$apply();
		if($scope.pagination.current > 1) {
			$('#ladderContent').scrollTop(curScrollHeight + $($scope.pagination.container + ' ' + $scope.pagination.itemContainer).height() * $scope.pagination.itemsPerPage);
		}

		pageUpdateFlag = true;
	};
	
	$('#ladderContent').scroll(function(){
		var top = $('#ladderContent').scrollTop();
		if($scope.pagination.current > 1 && pageUpdateFlag
	    	&& top < $($scope.pagination.container + ' ' + $scope.pagination.itemContainer).height() * $scope.pagination.itemsPerPage - $('#ladderContent').height()) {
	    	$scope.updateUpperLimits();
	    } else if($scope.pagination.current == 1 
	    	&& pageUpdateFlag
	    	&& top > $($scope.pagination.container + ' ' + $scope.pagination.itemContainer).height() * $scope.pagination.itemsPerPage - $('#ladderContent').height()){
	        $scope.updateLowerLimits();
	    } else if(top > 2 * $($scope.pagination.container + ' ' + $scope.pagination.itemContainer).height() * $scope.pagination.itemsPerPage - $('#ladderContent').height()
	    	&& pageUpdateFlag
	    	&& $scope.pagination.current < $scope.pagination.last) {
	    	$scope.updateLowerLimits();
		} 
	});

	$('.filterClassIcon').on('click', function(){
        if(!$(this).is('.checked')){
            $(this).addClass('checked');
            $scope.classFilter[$(this).data('id')] = true;
            $('#filterIcon').css('color', '#3498DB');
        } else {
            $(this).removeClass('checked');
            $scope.classFilter[$(this).data('id')] = false;
            if($('.filterClassIcon.checked').length == 0) {
            	$('#filterIcon').css('color', '')
            }
        }
        $scope.$apply();
    });

	$('.filterSpecIcon').on('click', function(){
        if(!$(this).is('.checked')){
            $(this).addClass('checked');
            if(!$(this).parent().siblings('.filterClassIcon').is('.checked')){
            	$(this).parent().siblings('.filterClassIcon').addClass('checked');
            }
            $scope.specFilter[$(this).data('id')] = true;
        } else {
            $(this).removeClass('checked');
            if($(this).siblings('.filterSpecIcon.checked').length == 0) {
            	if($(this).siblings('.filterClassIcon').is('.checked')){
            		$(this).parent().siblings('.filterClassIcon').removeClass('checked');
            	}
            } 
            $scope.specFilter[$(this).data('id')] = false;
        }
        $scope.$apply();
    });

	$(window).resize(function() {
	    $('#ladderContent').height($(window).height() - $('#ladderContent').offset().top - $('#pagination').height());
	});
	
	$scope.init();
}]);