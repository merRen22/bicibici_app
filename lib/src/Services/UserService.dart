import 'package:bicibici/src/Models/Storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import '../Values/Constants.dart';
import '../Models/User.dart';

class UserService {
  CognitoUserPool _userPool;
  CognitoUser _cognitoUser;
  CognitoUserSession _session;
  CognitoCredentials credentials;

  UserService(this._userPool);

  /// Initiate user session from local storage if present
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = Storage(prefs);
    _userPool.storage = storage;

    _cognitoUser = await _userPool.getCurrentUser();
    if (_cognitoUser == null) {
      return false;
    }
    _session = await _cognitoUser.getSession();
    return _session.isValid();
  }

  /// Get existing user from session with his/her attributes
  Future<User> getCurrentUser() async {
    //_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
    if (_cognitoUser == null || _session == null || !_session.isValid()) {
      return null;
    }
    final attributes = await _cognitoUser.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = User.fromUserAttributes(attributes);
    user.hasAccess = true;
    return user;
  }

  /// Retrieve user credentials -- for use with other AWS services
  Future<CognitoCredentials> getCredentials() async {
    if (_cognitoUser == null || _session == null) {
      return null;
    }
    credentials = CognitoCredentials(Constants.identityPoolId, _userPool);
    await credentials.getAwsCredentials(_session.getIdToken().getJwtToken());
    return credentials;
  }

  /// Login user
  Future<User> login(String email, String password) async {
    _cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );

    bool isConfirmed;
    try {
      _session = await _cognitoUser.authenticateUser(authDetails);
      isConfirmed = true;
    } on CognitoClientException catch (e) {
      print(e);
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        throw e;
      }
    }

    if (!_session.isValid()) {
      return null;
    }

    final attributes = await _cognitoUser.getUserAttributes();
    final user = User.fromUserAttributes(attributes);
    user.confirmed = isConfirmed;
    user.hasAccess = true;

    return user;
  }

  /// Confirm user's account with confirmation code sent to email
  Future<bool> confirmAccount(String email, String confirmationCode) async {
    _cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

    return await _cognitoUser.confirmRegistration(confirmationCode);
  }

  /// Resend confirmation code to user's email
  Future<void> resendConfirmationCode(String email) async {
    _cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
    await _cognitoUser.resendConfirmationCode();
  }

  /// Check if user's current session is valid
  Future<bool> checkAuthenticated() async {
    if (_cognitoUser == null || _session == null) {
      return false;
    }
    return _session.isValid();
  }

  Future<User> signUp(User user) async {
    var data;
    try {
      final userAttributes = [
        AttributeArg(name: 'address', value: user.address),
        AttributeArg(name: 'name', value: user.name),
        AttributeArg(name: 'phone_number', value: user.phone),
        ];
        
      data = await _userPool.signUp(user.email,user.password,userAttributes: userAttributes); 
    } catch (e) {
      print(e);
      throw e;
    }

    final userConfirmed = User();
    userConfirmed.email = user.email;
    userConfirmed.name = user.name;
    userConfirmed.confirmed = data.userConfirmed;

    return userConfirmed;
  }

  Future signOut() async {
    if (_cognitoUser != null) {
      return _cognitoUser.signOut();
    }
  }

  Future<bool> resetPassword(String oldPassword, String newPassword) async {
    bool passwordChanged = false;
    try {
      passwordChanged = await _cognitoUser.changePassword(oldPassword,newPassword);
    } catch (e) {
      print(e);
    }
    return passwordChanged;
  }

  Future<bool> deleteUser() async {
    bool userDeleted = false;
    try {
      userDeleted = await _cognitoUser.deleteUser();
    } catch (e) {
      print(e);
    }
    print(userDeleted);
    return userDeleted;
  }

  Future<bool> updateUserData(List<CognitoUserAttribute> attributes) async {
    bool _userDataUpadted = false;
    try {
      await _cognitoUser.updateAttributes(attributes);
      _userDataUpadted = true;
    } catch (e) {
      print(e);
      _userDataUpadted = false;
    }
    return _userDataUpadted;
  }
  
  Future<String> forgotPassword(String email) async {
    String data;
    try {
      final cognitoUser = CognitoUser(email, _userPool);
      data = await cognitoUser.forgotPassword();
    } catch (e) {
      print(e);
      data = "";
    }
    return data;
  }
  
  Future<bool> newPassword(User user) async {
    bool passwordChange = false;
    try {
      final cognitoUser = CognitoUser(user.email, _userPool);
      passwordChange = await cognitoUser.confirmPassword(user.codigo, user.password);
    } catch (e) {
      print(e);
    }
    return passwordChange;
  }

}