import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:software_encyclopedia/src/utils/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../../resources/firestore_methods.dart';
import '../utils/utils.dart';

class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({super.key});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  final _subcategoryNameController = TextEditingController();
  final _subcategoryDescriptionController = TextEditingController();
  String? _selectedCategory;
  String? _fileName = '';
  List<dynamic> _categories = [];
  Uint8List? _file;
  bool isAddingPost = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _subcategoryNameController.dispose();
    _subcategoryDescriptionController.dispose();
  }

  Future<void> _fetchCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final snapshot = await userDocRef.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final categoriesList = data['categories'] as List<dynamic>;
      setState(() {
        _categories =
            categoriesList.map((category) => category['name']).toList();
        print('_categories length : ${_categories.length}');
      });
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Uint8List file = await pickImage(ImageSource.camera);
                  var (rawImage, fileName) = await pickImage(ImageSource.camera);
                  Uint8List convertedImage = rawImage as Uint8List;
                  _fileName = fileName.toString();
                  
                  setState(() {
                    _file = convertedImage;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var (rawImage, fileName) = await pickImage(ImageSource.gallery);
                  Uint8List convertedImage = rawImage as Uint8List;
                  _fileName = fileName.toString();
                  
                  setState(() {
                    _file = convertedImage;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  

  void _addSubcategory() {
    print('2313 : $isAddingPost');
    if (isAddingPost) return;
    if (_subcategoryNameController.text.isNotEmpty && _subcategoryDescriptionController.text.isNotEmpty && _file != null) {
      setState(() {
        isAddingPost = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      postImage(user!.uid, user.email.toString(), _file);
    }
  }

   void postImage(String uid, String userEmail, dynamic subCategoryImg) async {

    try {
      String res = await FirestoreMethods().uploadSubCategoryImageWithDescription(
          _subcategoryDescriptionController.text, _subcategoryNameController.text, _file!, uid, userEmail, '');

      if (res == 'success') {
        if (!mounted) return;
        showSnackbar('Posted', context);
        _subcategoryDescriptionController.text = '';
        _subcategoryNameController.text = '';
        clearImage();
        setState(() {
          isAddingPost = false;
        });
      } else {
       
        if (!mounted) return;
        showSnackbar(res, context);
        setState(() {
          isAddingPost = false;
        });
      }
    } catch (error) {
      print('error ${error.toString()}');
      showSnackbar(error.toString(), context);
      setState(() {
        isAddingPost = false;
      });
    }
  }

   void clearImage() {
    setState(() {
      _file = null;
      _fileName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 40,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DropdownButtonFormField<String>(
                  //   value: _selectedCategory,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _selectedCategory = value;
                  //     });
                  //   },
                  //   items: _categories.map((category) {
                  //     return DropdownMenuItem<String>(
                  //       value: category,
                  //       child: Text(category),
                  //     );
                  //   }).toList(),
                  //   decoration:
                  //       const InputDecoration(labelText: 'Select Category'),
                  // ),
                  TextField(
                    controller: _subcategoryNameController,
                    decoration:
                        const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _subcategoryDescriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image',
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => _selectImage(context),
                            child: Container(
                              width: 160,
                              height: 40,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryShadowColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              child: const Center(
                                  child: Text(
                                'Choose Image',
                                style: TextStyle(color: AppColors.primaryColor),
                              )),
                            ),
                          ),
                          // Text('$_fileName', style: const TextStyle(fontSize: 11.0),),
                          _file != null ? SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ) : const SizedBox()
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _addSubcategory,
                    child:  isAddingPost ? const CircularProgressIndicator(color: AppColors.primaryColor,) : const Text('Add Feed'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
