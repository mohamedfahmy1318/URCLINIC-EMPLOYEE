import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../model/login_response.dart';

//region FIREBASE AUTH
final FirebaseAuth auth = FirebaseAuth.instance;
//endregion

class GoogleSignInAuthService {
  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  static Future<UserData> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.attemptLightweightAuthentication();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User user = authResult.user!;
      assert(!user.isAnonymous);

      final User currentUser = auth.currentUser!;
      assert(user.uid == currentUser.uid);

      log('CURRENTUSER: $currentUser');

      // await googleSignIn.signOut();

      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').isNotEmpty) {
        firstName = currentUser.displayName.splitBefore(' ');
      }
      if (currentUser.displayName.validate().split(' ').length >= 2) {
        lastName = currentUser.displayName.splitAfter(' ');
      }

      /// Create a temporary request to send
      final UserData tempUserData = UserData()
        ..mobile = currentUser.phoneNumber.validate()
        ..email = currentUser.email.validate()
        ..firstName = firstName.validate()
        ..lastName = lastName.validate()
        ..profileImage = currentUser.photoURL.validate()
        ..loginType = LoginTypeConst.LOGIN_TYPE_GOOGLE
        ..userName = currentUser.displayName.validate();

      return tempUserData;
    } else {
      throw locale.value.userNotCreated;
    }
  }

  // region Apple Sign
  static Future<UserData> signInWithApple() async {
    if (await SignInWithApple.isAvailable()) {
      try {
        final AuthorizationCredentialAppleID appleIdCredential =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final AuthCredential credential = oAuthProvider.credential(
          idToken: appleIdCredential.identityToken,
          accessToken: appleIdCredential.authorizationCode,
        );

        final UserCredential authResult =
            await auth.signInWithCredential(credential);
        final User user = authResult.user!;
        assert(!user.isAnonymous);

        final User currentUser = auth.currentUser!;
        assert(user.uid == currentUser.uid);

        String firstName =
            appleIdCredential.givenName.validate(value: '').trim();
        String lastName =
            appleIdCredential.familyName.validate(value: '').trim();

        if (firstName.isEmpty &&
            currentUser.displayName.validate().isNotEmpty) {
          firstName = currentUser.displayName.splitBefore(' ').validate();
        }
        if (lastName.isEmpty &&
            currentUser.displayName.validate().contains(' ')) {
          lastName = currentUser.displayName.splitAfter(' ').validate();
        }

        final String resolvedEmail = currentUser.email.validate().isNotEmpty
            ? currentUser.email.validate()
            : appleIdCredential.email.validate();

        final String fullName =
            '${firstName.validate()} ${lastName.validate()}'.trim();

        final UserData tempUserData = UserData()
          ..mobile = currentUser.phoneNumber.validate()
          ..email = resolvedEmail
          ..firstName = firstName
          ..lastName = lastName
          ..profileImage = currentUser.photoURL.validate()
          ..loginType = LoginTypeConst.LOGIN_TYPE_APPLE
          ..userName =
              fullName.isEmpty ? currentUser.displayName.validate() : fullName;

        return tempUserData;
      } on SignInWithAppleAuthorizationException catch (e) {
        if (e.code == AuthorizationErrorCode.canceled) {
          throw locale.value.userCancelled;
        }
        throw '${locale.value.signInFailed}: ${e.message}';
      } catch (e) {
        throw '${locale.value.signInFailed}: $e';
      }
    } else {
      throw locale.value.appleSigninIsNot;
    }
  }
}
