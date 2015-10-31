angular.module('app').controller('CharacterCtrl', function($scope, $http, $timeout) {
	
	$scope.init = function() {
		$scope.characters = [];
		$scope.filteredCharacters = [];
		$scope.limitVar = 150;
		$scope.beginVar = 0;
		$scope.limitStep = 50;
		$scope.query = "";
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
	
	$scope.getLadder = function(region, bracket){
		$('#loadingGif').show();
		$http.get(
			"/character/ladderJson",
			{ 
				params: {
					region: region,
					bracket: bracket
				}
			}
		).success(function(data) {
			$scope.characters = data;
			$('#loadingGif').hide();
		});
	};

	$scope.getRecent = function(region, bracket){
		$('#loadingGif').show();
		$http.get(
			"/match_history/list",
			{ 
				params: {
					region: region,
					bracket: bracket
				}
			}
		).success(function(data) {
			$scope.characters = data;
			$('#loadingGif').hide();
		});
	};

	$scope.updateLowerLimits = function() {
		console.log('updating lower limits');
		pageUpdateFlag = false;
		var curScrollHeight = $('#ladderContent').scrollTop();
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
	    	&& pageUpdateFlag) {
	    	$scope.updateLowerLimits();
		} 
	});

	$('.filterClassIcon').on('click', function(){
        if(!$(this).is('.checked')){
            $(this).addClass('checked');
            //$(this).siblings('.filterIconSpecs').animate({right:0}, 'slow');
            //$(this).siblings('.filterIconSpecs').children().each(function() {
            	$scope.classFilter[$(this).data('id')] = true;
            	//if(!$(this).is('.checked')) {
            	//	$(this).addClass('checked');
            	//}
            //});
        } else {
            $(this).removeClass('checked');
            //$(this).siblings('.filterIconSpecs').animate({right:-200}, 'slow');
            //$(this).siblings('.filterIconSpecs').children().each(function() {
            	$scope.classFilter[$(this).data('id')] = false;
            	//if($(this).is('.checked')) {
            	//	$(this).removeClass('checked');
            	//}
            //});
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
	    $('#ladderContent').height($(window).height() - $('#ladderContent').offset().top);
	});
	
	$scope.init();
});