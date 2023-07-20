import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
/* This page is where user information is verified, saved to the database,
and the total expense amount is recorded to the database by date.

The signIn() function uses the authentication service
to verify the email and password entered by the user on the login page when logging in.

The signUp() function creates fields in the Firebase database for new users under the names email,
password, name, surname, and expenses, and transfers the user's information to Firebase.

If the email is already in use, the function uses try-catch blocks to
return a message to the user stating that the email is already in use.

The addExpense() function records the expense to the Firebase database through the query
"firebaseFirestore.collection("Users").doc(userId).update()".

We will use the getExpenses() function to analyze the data. */
class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  User? get user => firebaseAuth.currentUser;

  Future<String?> signIn(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          res = "User not found";
          break;
        case "wrong-password":
          res = "Wrong Password";
          break;
        default:
          res = e.message;
          break;
      }
    }
    return res;
  }

  Future<String?> signUp(
      String email, String username, String lastname, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final userId = result.user!.uid;
      try {
        await firebaseFirestore.collection("Users").doc(userId).set({
          "email": email,
          "name": username,
          "surname": lastname,
          "password": password,
          "expenses": [],
        });
        res = "success";
      } catch (e) {
        print("$e");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          res = "Email already in use";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          res = "Invalid email";
          break;
        default:
          res = e.message;
          break;
      }
    }
    return res;
  }

  Future<String?> addExpense(double totalPrice) async {
    String? res;
    try {
      final userId = user!.uid;
      final today = DateTime.now();
      final date = Timestamp.fromDate(today);
      final expensesData = await firebaseFirestore.collection("Users").doc(userId).update({
        "expenses": FieldValue.arrayUnion([
          {"date": date, "totalprice": totalPrice}
        ]),
      });
      res = "success";
    } catch (e) {
      print("$e");
    }
    return res;
  }

  Future<List<dynamic>> getExpenses() async {
    try {
      final userId = user!.uid;
      final userData =
      await firebaseFirestore.collection("Users").doc(userId).get();
      final expenses = userData.get("expenses");
      return expenses;
    } catch (e) {
      print("$e");
      return [];
    }
  }
}