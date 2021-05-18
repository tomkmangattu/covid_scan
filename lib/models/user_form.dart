import 'dart:io';
import 'package:covid_scan/cubit/userdata_cubit.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'UserData.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  UserData _userData = UserData();
  File _image;
  double _width;
  final _picker = ImagePicker();
  VaccineStatus _vaccineStatus = VaccineStatus.one;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: _globalKey,
        child: Column(
          children: [
            _image == null
                ? Container(
                    width: _width - 20,
                    height: _width - 20,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      children: [
                        _imagePickerButton(),
                        Center(
                          child: Text('No Profile Picture chossed'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image)),
                        _imagePickerButton(),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String value) {
                  _userData.name = value;
                },
                keyboardType: TextInputType.name,
                validator: (String value) {
                  if (value.isEmpty || value == null)
                    return 'User name cannot be empty';

                  return null;
                },
                decoration: formdecoration.copyWith(
                    hintText: 'Enter name', suffixText: '*'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String value) {
                  _userData.emailId = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: formdecoration.copyWith(hintText: 'Enter email Id'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String value) {
                  _userData.pinCode = value;
                },
                keyboardType: TextInputType.number,
                decoration:
                    formdecoration.copyWith(hintText: 'Enter your pincode'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String value) {
                  _userData.age = value;
                },
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: formdecoration.copyWith(
                    hintText: 'Enter your age', counterText: ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vaccination status:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text('None'),
                            Radio(
                              value: VaccineStatus.none,
                              groupValue: _vaccineStatus,
                              onChanged: (VaccineStatus status) {
                                setState(() {
                                  _vaccineStatus = status;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('One Dose'),
                            Radio(
                              value: VaccineStatus.one,
                              groupValue: _vaccineStatus,
                              onChanged: (VaccineStatus status) {
                                setState(() {
                                  _vaccineStatus = status;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Two'),
                            Radio(
                              value: VaccineStatus.two,
                              groupValue: _vaccineStatus,
                              onChanged: (VaccineStatus status) {
                                setState(() {
                                  _vaccineStatus = status;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: _proceed,
              child: Container(
                width: _width,
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                decoration: kLoginButtonDec,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  void _unfocus() {
    final focus = FocusScope.of(context);
    if (focus.hasPrimaryFocus) {
      focus.unfocus();
    }
  }

  void _proceed() {
    _unfocus();
    if (_globalKey.currentState.validate()) {
      BlocProvider.of<UserdataCubit>(context).uploadData(
          userData: _userData, vaccineStatus: _vaccineStatus, file: _image);
    }
  }

  Align _imagePickerButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 24,
          child: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _uploadProfilePicture,
          ),
        ),
      ),
    );
  }

  void _uploadProfilePicture() {
    _unfocus();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt),
                      Text('Take picture'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sd_storage),
                      Text('Select form Media')
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _getImage(ImageSource imgsrc) async {
    final PickedFile pickedFile = await _picker.getImage(
        source: imgsrc, imageQuality: 12, maxWidth: 500, maxHeight: 500);
    if (pickedFile != null) {
      Navigator.pop(context);
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
