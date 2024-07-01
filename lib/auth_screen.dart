import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'image_screen.dart';

class AuthScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isLogin = true.obs;

  Future<void> _submit() async {
    try {
      if (_isLogin.value) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
      Get.off(ImageScreen());
    } catch (error) {
      print(error);
      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0e1117),
      appBar: AppBar(
        backgroundColor: Color(0xffe84a4b),
        centerTitle: true,
        title: Obx(() => Text(
              _isLogin.value ? 'Login' : 'Register',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.sp),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontSize: 18.sp,
                  color: Color(0xffe84a4b),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .white), // White color when the TextField is not focused
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .white), // White color when the TextField is focused
                ),
              ),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15.h),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontSize: 18.sp,
                  color: Color(0xffe84a4b),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .white), // White color when the TextField is not focused
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .white), // White color when the TextField is focused
                ),
              ),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
              obscureText: true,
            ),
            SizedBox(height: 30.h),
            Container(
              height: 50.h,
              width: 170.w,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xffe84a4b)),
                ),
                onPressed: _submit,
                child: Obx(() => Text(
                      _isLogin.value ? 'Login' : 'Register',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    )),
              ),
            ),
            TextButton(
              onPressed: () => _isLogin.value = !_isLogin.value,
              child: Obx(() => Text(
                    _isLogin.value
                        ? 'Create an account'
                        : 'Have an account? Login',
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
