angular.module('app').controller('CharacterCtrl', function($scope, $http) {
	
	$scope.init = function() {
		$scope.characters = []
	};
	
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

	$scope.init();
});