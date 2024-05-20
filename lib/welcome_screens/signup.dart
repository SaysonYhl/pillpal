import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/pages/home_page.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //create account
    try {
      //check password-confpass
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pop(context);
        showErrorMessage('Password does not match');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
    //logout method sa profile
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kErrorBorderColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            title: Center(
              child: Text(message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    //fontFamily: 'Raleway',
                    fontWeight: FontWeight.w900,
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Sign Up',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 14, 128, 75),
                  Color.fromARGB(255, 4, 110, 61),
                  Color.fromARGB(255, 1, 69, 37),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  SizedBox(
                    height: 30.h,
                    width: 60.w,
                    child: Image.asset('assets/images/whitelogowtext.png'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      reusableTextField(
                          Icons.mail_outline, false, emailController, 400, 50),
                      SizedBox(
                        height: 15,
                      ),
                      const Text('Password',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      reusableTextField(
                          Icons.lock_outline, true, passwordController, 400, 50),
                      SizedBox(
                        height: 15,
                      ),
                      const Text('Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      reusableTextField(Icons.lock_outline, true,
                          confirmPasswordController, 400, 50),
                      SizedBox(
                        height: 3.h,
                      ),
                    ],
                  ),
                  signInSignUpButton(context, false, () {
                    signUp();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Container reusableTextField(IconData icon, bool isPasswordType,
    TextEditingController controller, double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      border: Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
      color: Colors.white.withOpacity(0.2),
    ),
    child: TextField(
      controller: controller,
      obscureText: isPasswordType,
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 2),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.0),
            width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
      ),
    );
}


Container signInSignUpButton(BuildContext context, bool isLogin, Function onTap){
  return Container(
    width: 200,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(onPressed: (){
      onTap();
    },
     child: Text(
      isLogin ? 'Sign In' : 'Sign Up',
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16
      ),
     ),
     style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.black45;
        }
        return Colors.white;
      })
     ),),
  );
}