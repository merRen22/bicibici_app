import 'package:amazon_cognito_identity_dart/cognito.dart';

class Constants{

// Setup AWS User Pool Id & Client Id settings here:
static const awsUserPoolId = 'us-east-2_rsfMfP3VZ';
static const awsClientId = '1kaumgehk9rbf1phq4rmok8qnf';

static const identityPoolId = 'us-east-1:6f93ed0c-5c69-43a1-b795-d15d3339eee6';

// Setup endpoints here:
static const region = 'us-east-2';
//static const endpoint = 'https://xxxxxxxxxx.execute-api.ap-southeast-1.amazonaws.com/dev';

static final userPool = new CognitoUserPool(awsUserPoolId, awsClientId);
}