angular.module('app').controller('CharacterClassesCtrl', ['$scope', function($scope) {
	$scope.setClasses = function(classes) {
		$scope.classes = classes
	}
}]);