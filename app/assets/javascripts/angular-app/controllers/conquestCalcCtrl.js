angular.module('app').controller('ConquestCalcCtrl', function($scope) {

	$scope.init = function() {
		$scope.rating = 1500;
		$scope.cap = 1700;
		$scope.calculateVar = 'rating';
	}

	$scope.$watch('rating', function() {
		if($scope.calculateVar == 'rating') {
			calculate();
		}
	});

	$scope.$watch('cap', function() {
		if($scope.calculateVar == 'cap') {
			calculate();
		}
	});

	calculateCapFromRating = function() {
		if($scope.rating > 1500) {
			$scope.cap = Math.round(($scope.rating - 1500) * 1.8) + 1700
		} else {
			$scope.cap = 1700
		}
	}

	calculateRatingFromCap = function() {
		if($scope.cap > 1700) {
			$scope.rating = Math.round(($scope.cap - 1700) / 1.8) + 1500
		} else {
			$scope.rating = 1500
		}
	}

	$scope.switchCalculation = function() {
		$('#' + $scope.calculateVar).prop('disabled', true)
		if($scope.calculateVar == 'cap') {
			$scope.calculateVar = 'rating'
		} else {
			$scope.calculateVar = 'cap'
		}
		$('#' + $scope.calculateVar).prop('disabled', false)
		calculate();
	}

	calculate = function() {
		if($scope.calculateVar == 'cap') {
			calculateRatingFromCap();
		} else {
			calculateCapFromRating();
		}
	}

	$scope.init();

});