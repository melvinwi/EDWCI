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
	var cState = '';
	var cRating = '';

	// init
	$scope.customerCode = '';
	$scope.customerName = '';
	$scope.customerState = '';
	$scope.customerRating = '';
	$scope.maxElecOffer = 'Unknown';
	$scope.maxGasOffer = 'Unknown';
	$scope.potentialInducement = 'None';

    $scope.getCustomerRating = function(account) {

    	
		var CustomerRating = $resource('/api/:apiName/:token?theCustomerId=:account', {apiName: 'CustomerRating', token: token, account: account.id});
		CustomerRating.get(function(object) {

			$scope.customerCode = account.id;
			$scope.customerName = 'No Results';
			$scope.customerState = 'No Results';
			$scope.customerRating = 'No Results';
			$scope.maxElecOffer = 'Unknown';
			$scope.maxGasOffer = 'Unknown';
			$scope.potentialInducement = 'None';

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
				$scope.customerCode = account.id;
				$scope.customerName = 'No Results';
				$scope.customerState = 'No Results';
				$scope.customerRating = 'No Results';
			}
			else {
				if (object.CustomerRating[0].CustomerName!=undefined) {
					
					cName = object.CustomerRating[0].CustomerName.toString();
					cState = object.CustomerRating[0].CustomerState.toString();
					cRating = object.CustomerRating[0].CustomerRating.toString();
					
					$scope.customerCode = account.id;
					$scope.customerName = cName;
					$scope.customerState = cState;
					$scope.customerRating = cRating;
				
					
					if (cState == 'VIC') {
						switch (cRating) {
							 case 'Platinum':
								 $scope.maxElecOffer = 'Advantage 25% + $50 rebate';
								 $scope.maxGasOffer = 'Advantage 15% + $50 rebate';
								 break; 
							 case 'Gold':
								 $scope.maxElecOffer = 'Advantage 25% + $25 rebate';
								 $scope.maxGasOffer = 'Advantage 15% + $25 rebate';
								 break; 
							case 'Silver':
								 $scope.maxElecOffer = 'Advantage 25%';
								 $scope.maxGasOffer = 'Advantage 15% + $25 rebate';
								 break; 
							case 'Bronze':
								 $scope.maxElecOffer = 'Advantage 22%';
								 $scope.maxGasOffer = 'Advantage 15%';
								 break; 
							 default: 
								 $scope.maxElecOffer = 'Unknown';
								 $scope.maxGasOffer = 'Unknown';
						}
					}						
						
						
					if (cState == 'NSW') {
						switch (cRating) {
							 case 'Platinum':
								 $scope.maxElecOffer = 'Advantage 10% + $50 rebate';
								 $scope.maxGasOffer = 'Advantage 10% + $50 rebate';
								 break; 
							 case 'Gold':
								 $scope.maxElecOffer = 'Advantage 10% + $25 rebate';
								 $scope.maxGasOffer = 'Advantage 10% + $25 rebate';
								 break; 
							case 'Silver':
								 $scope.maxElecOffer = 'Advantage 10%';
								 $scope.maxGasOffer = 'Advantage 10%';
								 break; 
							case 'Bronze':
								 $scope.maxElecOffer = 'Advantage 5%';
								 $scope.maxGasOffer = 'Advantage 5%';
								 break; 
							 default: 
								 $scope.maxElecOffer = 'Unknown';
								 $scope.maxGasOffer = 'Unknown';
						}
					}
						
					if (cState == 'QLD') {
						switch (cRating) {
							 case 'Platinum':
								 $scope.maxElecOffer = 'Advantage 10% + $50 rebate';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							 case 'Gold':
								 $scope.maxElecOffer = 'Advantage 10% + $25 rebate';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							case 'Silver':
								 $scope.maxElecOffer = 'Advantage 10%';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							case 'Bronze':
								 $scope.maxElecOffer = 'Advantage 5%';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							 default: 
								 $scope.maxElecOffer = 'Unknown';
								 $scope.maxGasOffer = 'Not Applicable';
						}
					}
						
					if (cState == 'SA') {
						switch (cRating) {
							 case 'Platinum':
								 $scope.maxElecOffer = 'Advantage 15% + $50 rebate';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							 case 'Gold':
								 $scope.maxElecOffer = 'Advantage 15% + $25 rebate';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							case 'Silver':
								 $scope.maxElecOffer = 'Advantage 15%';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							case 'Bronze':
								 $scope.maxElecOffer = 'Advantage 15%';
								 $scope.maxGasOffer = 'Not Applicable';
								 break; 
							 default: 
								 $scope.maxElecOffer = 'Unknown';
								 $scope.maxGasOffer = 'Not Applicable';
						}
					}
					
					switch (cRating) {
							 case 'Platinum':
								 $scope.potentialInducement = 'Movie Fan (12 tickets for 6 months)';
								
								 break; 
							 case 'Gold':
								 $scope.potentialInducement = 'Movie Fan (12 tickets for 6 months)';
								
								 break; 
							case 'Silver':
								 $scope.potentialInducement = 'Quickflix 6 months';
								
								 break; 
							case 'Bronze':
								 $scope.potentialInducement = 'No offer';
								
								 break; 
							 default: 
								 $scope.potentialInducement = 'Unknown';
					}
						
				}
				else {
					$scope.status = 'Account Id was not found';
					$scope.customerCode = account.id;
					$scope.customerName = 'No Results';
					$scope.customerState = 'No Results';
					$scope.customerRating = 'No Results';
				}
			}

		});
        
    };


});