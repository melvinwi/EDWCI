var webapp = angular.module('webapp', ['ngResource', 'ngRoute'])


// global variables
var token = '';
var username = '';

// header
webapp.controller('AppController', function AppController($scope, $resource) {



// login components controller logic

	$scope.showLoginController = true;

    $scope.loginUser = function(login) {

		var Authenticate = $resource('/auth/:username/:password', {username: login.username, password: login.password});
		Authenticate.get(function(object) {
			
			if (object.ERROR) {
				$scope.status = object.ERROR;
				token = object.token;
			}
			else {
				$scope.status = '';
				token = object.token;
				username = object.username;

				$scope.showLoginController = false;
				$scope.showAccountController = true;
			}
		});
    };



// account component controller logic

	var cName = '';
	var cRating = '';

	// init
	$scope.customerName = '...';
	$scope.customerRating = '...';

    $scope.getCustomerRating = function(account) {

    	
		var CustomerRating = $resource('/api/:apiName/:token?theCustomerId=:account', {apiName: 'CustomerRating', token: token, account: account.id});
		CustomerRating.get(function(object) {
			
			$scope.customerName = '...';
			$scope.customerRating = '...';

			if (object.ERROR!=undefined) {
				if (object.ERROR.indexOf('has expired')!=-1) {
					$scope.customerRatingStatus = 'Session has expired - please Login';

					setTimeout(function() {
						$scope.showLoginController = true;
						$scope.showAccountController = false;
					}, 2000);
				}
				else {
					$scope.customerRatingStatus = object.ERROR;
				}

				$scope.customerName = '...';
				$scope.customerRating = '...';
			}
			else {
				if (object.CustomerRating[0].CustomerName!=undefined) {
					
					cName = object.CustomerRating[0].CustomerName.toString();
					cRating = object.CustomerRating[0].CustomerRating.toString();
					$scope.customerName = cName;
					$scope.customerRating = cRating;
				}
				else {
					$scope.status = 'Account Id was not found';
					$scope.customerName = '';
					$scope.customerRating = '';
				}
			}
		});
        
    };


});