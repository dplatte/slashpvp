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
	};

	var pageUpdateFlag = true;

	$scope.$watchCollection('classFilter', function() {
		$scope.beginVar = 0;
		$('#ladderContent').scrollTop(0);
	});

	$scope.$watchCollection('filteredCharacters', function() {
		if($scope.filteredCharacters.length) {
			$scope.setCurrentPage(1);
			$('#loadingGif').hide();
		} else {
			$('#loadingGif').show();
		}
		console.log("characters size: " + $scope.filteredCharacters.length);

		//$('#ladderContent').scrollTop(0);
	});

	$scope.$watchCollection('pages', function() {
		$('#ladderContent').height($(window).height() - $('#ladderContent').offset().top);
	});

	$scope.$watch('query', function() {
		$scope.beginVar = 0;
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

		console.log('setting current page');
		console.log("begin var: " + $scope.beginVar);
		console.log("limit var: " + $scope.limitVar);
		console.log("current var: " + $scope.pagination.current);
		console.log("scrolltop var: " + $('#ladderContent').scrollTop());
		console.log("scrollheight var: " + $('#ladderContent')[0].scrollHeight);
		
	};

	$scope.updateCurrentPage = function(page) {
		$scope.pagination.last = Math.ceil($scope.filteredCharacters.length / $scope.pagination.itemsPerPage);

		var firstDisplayPage = 1;
		var lastDisplayPage = 1;
		if(page + 4 < 9) {
			lastDisplayPage = 9;
		} else {
			lastDisplayPage = page + 4;
		}
		if($scope.pagination.last < lastDisplayPage) {
			lastDisplayPage = $scope.pagination.last;
		}
		if(page - 4 < 1) {
			firstDisplayPage = 1;
		} else {
			firstDisplayPage = page - 4;
		}

		$scope.pages = [];
		for (var i = firstDisplayPage; i <= lastDisplayPage; i++) {
		    $scope.pages.push(i);
		}

		$scope.pagination.current = page;
	}

	$scope.customCharacterFilter = function (character) {
	    // Display the wine if
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

	    // No checkbox was found to be checked
	    return true;
	}
	
	$scope.getLadder = function(region, bracket){

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
		});
	};

	$scope.updateLowerLimits = function() {

		var curScrollHeight = $('#ladderContent').scrollTop();
		pageUpdateFlag = false;
		console.log(parseInt($scope.pagination.current));
		console.log('updating lower limits');
		var current = $scope.pagination.current;
		$scope.updateCurrentPage($scope.pagination.current + 1);
		if(current > 1) {
			$scope.beginVar += 50;
		} else {
			curScrollHeight += $('#ladderContent')[0].scrollHeight / 3;
		}
		$scope.$apply();
		console.log("current var: " + $scope.pagination.current);
		console.log("scrolltop var: " + $('#ladderContent').scrollTop());
		console.log("scrollheight var: " + $('#ladderContent')[0].scrollHeight);

		//FIX THIS FOR FIRST SCROLL UP
		$('#ladderContent').scrollTop(curScrollHeight - $('#ladderContent')[0].scrollHeight / 3);

		console.log("Size of limit: " + $scope.limitVar);
		pageUpdateFlag = true;
	};

	$scope.updateUpperLimits = function() {
		pageUpdateFlag = false;
		console.log(parseInt($scope.pagination.current));
		console.log('updating upper limits');
		$scope.updateCurrentPage($scope.pagination.current - 1);
		
		if($scope.pagination.current > 1) {
			$scope.beginVar -= 50;
		}
		console.log("begin var: " + $scope.beginVar);
		console.log("limit var: " + $scope.limitVar);
		console.log("current var: " + $scope.pagination.current);
		console.log("scrolltop var: " + $('#ladderContent').scrollTop());
		console.log("scrollheight var: " + $('#ladderContent')[0].scrollHeight);
		$scope.$apply();
		if($scope.pagination.current > 1) {
			$('#ladderContent').scrollTop(2 * $('#ladderContent')[0].scrollHeight / 3 - $('#ladderContent').height() - 10);
		}

		pageUpdateFlag = true;
	};

	$('#ladderContent').scroll(function(){
		var top = $('#ladderContent').scrollTop();
		if($scope.pagination.current > 1 && pageUpdateFlag
	    	&& top < $('#ladderContent')[0].scrollHeight / 3 - $('#ladderContent').height() 
	    	&& $scope.filteredCharacters.length > $scope.beginVar + $scope.limitVar) {
	    	$scope.updateUpperLimits();
	    } else if($scope.pagination.current == 1 
	    	&& pageUpdateFlag
	    	&& top > $('#ladderContent')[0].scrollHeight / 3 - $('#ladderContent').height() 
	    	&& $scope.filteredCharacters.length > $scope.beginVar + $scope.limitVar){
	        $scope.updateLowerLimits();
	    } else if(top > 2 * $('#ladderContent')[0].scrollHeight / 3 - $('#ladderContent').height() 
	    	&& pageUpdateFlag
	    	&& $scope.filteredCharacters.length > $scope.beginVar + $scope.limitVar) {
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
        console.log($scope.specFilter[$(this).data('id')]);
        $scope.$apply();
    });

	$(window).resize(function() {
	    $('#ladderContent').height($(window).height() - $('#ladderContent').offset().top);
	});

	$(window).trigger('resize');
	
	$scope.init();
});