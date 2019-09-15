import 'package:amazon_cognito_identity_dart/cognito.dart';

class Constants{
static const awsUserPoolId = 'us-east-1_6Z8jDYymQ';
static const awsClientId = '5tebavse3mbm94ijnrcjnl7tnf';
static const identityPoolId = 'us-east-1:747369759843:userpool/us-east-1_6Z8jDYymQ';
static const region = 'us-east-1';
static final userPool = CognitoUserPool(awsUserPoolId, awsClientId);

static final stationsEndPoint = 'https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com/dev';
}