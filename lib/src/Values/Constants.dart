import 'package:amazon_cognito_identity_dart/cognito.dart';

class Constants{
static const awsUserPoolId = 'us-east-1_Id1i22EAb';
static const awsClientId = '2ohrenpjdm7evjmd8qlpjd7ea0';
static const identityPoolId = 'us-east-1:747369759843:userpool/us-east-1_Id1i22EAb';
static const region = 'us-east-1';
static final userPool = CognitoUserPool(awsUserPoolId, awsClientId);

static final stationsEndPoint = "";
}