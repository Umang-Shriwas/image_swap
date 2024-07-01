import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api_service.dart';

class ImageScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final _baseImageFile = Rx<File?>(null);
  final _clothesImageFile = Rx<File?>(null);
  final _resultImageUrl = Rx<String?>(null);
  final _selectedClothingType = RxString('upper_body');
  final _isLoadingSwap = RxBool(false);
  final _isLoadingCreate = RxBool(false);

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _pickBaseImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _baseImageFile.value = File(pickedFile.path);
      showToast('Base image selected');
    } else {
      showToast('No base image selected');
    }
  }

  Future<void> _pickClothesImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _clothesImageFile.value = File(pickedFile.path);
      showToast('Clothes image selected');
    } else {
      showToast('No clothes image selected');
    }
  }

  Future<void> _swapClothes() async {
    if (_baseImageFile.value != null && _clothesImageFile.value != null) {
      _isLoadingSwap.value = true;
      showToast('Swapping clothes...');
      final baseImageBytes = await _baseImageFile.value!.readAsBytes();
      final clothesImageBytes = await _clothesImageFile.value!.readAsBytes();
      final imageUrl = await ApiService().swapClothes(
          _selectedClothingType.value, baseImageBytes, clothesImageBytes);
      if (imageUrl != null) {
        _resultImageUrl.value = imageUrl;
        showToast('Clothes swapped successfully');
      } else {
        showToast('Failed to swap clothes');
      }
      _isLoadingSwap.value = false;
    } else {
      showToast('Please select both base image and clothes image');
    }
  }

  Future<void> _createClothes() async {
    if (_baseImageFile.value != null) {
      _isLoadingCreate.value = true;
      showToast('Creating clothes design...');
      final baseImageBytes = await _baseImageFile.value!.readAsBytes();
      final imageUrl = await ApiService().createClothes(
          _selectedClothingType.value, 'some prompt', baseImageBytes);
      if (imageUrl != null) {
        _resultImageUrl.value = imageUrl;
        showToast('Clothes design created successfully');
      } else {
        showToast('Failed to create clothes design');
      }
      _isLoadingCreate.value = false;
    } else {
      showToast('Please select a base image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe1117),
      appBar: AppBar(
        backgroundColor: Color(0xffe84a4b),
        centerTitle: true,
        title: Text(
          'Swap Cloth',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Select Body Type",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedClothingType.value,
                      dropdownColor: Color(0xffffffff),
                      iconEnabledColor: Colors.white,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: TextStyle(color: Colors.red),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _selectedClothingType.value = newValue;
                        }
                      },
                      items: <String>['upper_body', 'lower_body', 'dress']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                )),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 160.w,
                  child: Column(
                    children: [
                      Obx(() => _baseImageFile.value != null
                          ? Container(
                              height: 200.h,
                              child: Image.file(_baseImageFile.value!))
                          : SizedBox.shrink()),
                      InkWell(
                        onTap: _pickBaseImage,
                        child: Container(
                          height: 50.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: Color(0xffe84a4b), width: 2.h)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera,
                                  size: 20.h,
                                  color: Color(0xffe84a4b),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  'Pick Base Image',
                                  style: TextStyle(color: Color(0xffe84a4b)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 160.w,
                  child: Column(
                    children: [
                      Obx(() => _clothesImageFile.value != null
                          ? Container(
                              height: 200.h,
                              child: Image.file(_clothesImageFile.value!))
                          : SizedBox.shrink()),
                      InkWell(
                        onTap: _pickClothesImage,
                        child: Container(
                          height: 50.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: Color(0xffe84a4b), width: 2.h)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo_camera_front_outlined,
                                    size: 20.sp,
                                    color: Color(0xffe84a4b),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Text(
                                    'Pick Clothes Image',
                                    style: TextStyle(color: Color(0xffe84a4b)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => InkWell(
                      onTap: () {
                        if (!_isLoadingSwap.value) _swapClothes();
                      },
                      child: Container(
                        height: 50.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                            color: Color(0xffe84a4b),
                            borderRadius: BorderRadius.circular(10.r),
                            border:
                                Border.all(color: Colors.white, width: 2.h)),
                        child: Center(
                          child: _isLoadingSwap.value
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Swap Clothes',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    )),
                Obx(() => InkWell(
                      onTap: () {
                        if (!_isLoadingCreate.value) _createClothes();
                      },
                      child: Container(
                        height: 50.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                            color: Color(0xffe84a4b),
                            borderRadius: BorderRadius.circular(10.r),
                            border:
                                Border.all(color: Colors.white, width: 2.h)),
                        child: Center(
                          child: _isLoadingCreate.value
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Create Design',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Obx(() => Container(
                  height: 300.h,
                  width: 300.w,
                  child: _resultImageUrl.value != null
                      ? Image.network(_resultImageUrl.value!)
                      : SizedBox.shrink(),
                ))
          ],
        ),
      ),
    );
  }
}
