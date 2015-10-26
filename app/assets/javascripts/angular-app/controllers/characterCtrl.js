angular.module('app').controller('CharacterCtrl', function($scope, $http) {
	
	$scope.init = function() {
		$scope.characters = [];
		$scope.limitVar = 100;
		$scope.beginVar = 0;
		$scope.limitStep = 50;
		$scope.query = "";
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
	};

	$scope.$watchCollection('specFilter', function() {
		$scope.beginVar = 0;
		$('#ladderContent').scrollTop(0);
	});

	$scope.customCharacterFilter = function (character) {
	    // Display the wine if
	    var re = new RegExp($scope.query, 'i');

	    return ($scope.specFilter[character.character_spec_id] || 
	    	noFilter($scope.specFilter)) &&
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
		console.log('updating lower limits');
		$scope.beginVar += 50;
		$scope.$apply();
		$('#ladderContent').scrollTop($('#ladderContent')[0].scrollHeight / 2 - $('#ladderContent').height());
	};

	$scope.updateUpperLimits = function() {
		console.log('updating upper limits');
		$scope.beginVar -= 50;
		$scope.$apply();
		$('#ladderContent').scrollTop($('#ladderContent')[0].scrollHeight / 2);
		$('#ladderContent').scrollTop();
	};

	$('#ladderContent').scroll(function(){
	    if ($('#ladderContent').scrollTop() == $('#ladderContent')[0].scrollHeight - $('#ladderContent').height() && $scope.filteredCharacters.length > $scope.beginVar + $scope.limitVar){
	        $scope.updateLowerLimits();
	    } else if($('#ladderContent').scrollTop() <= 0 && $scope.beginVar > 0) {
	    	$scope.updateUpperLimits();
	    }
	});

	$('.filterClassIcon').on('click', function(){
        if(!$(this).is('.checked')){
            $(this).addClass('checked');
            $(this).siblings('.filterIconSpecs').animate({right:0}, 'slow');
            $(this).siblings('.filterIconSpecs').children().each(function() {
            	$scope.specFilter[$(this).data('id')] = true;
            	if(!$(this).is('.checked')) {
            		$(this).addClass('checked');
            	}
            });
        } else {
            $(this).removeClass('checked');
            $(this).siblings('.filterIconSpecs').animate({right:-200}, 'slow');
            $(this).siblings('.filterIconSpecs').children().each(function() {
            	$scope.specFilter[$(this).data('id')] = false;
            	if($(this).is('.checked')) {
            		$(this).removeClass('checked');
            	}
            });
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

	$('#ladderContent').height($(window).height() - $('#ladderContent').offset().top);
	$scope.init();
});