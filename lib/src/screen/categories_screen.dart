import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categoryNameController = TextEditingController();
  String? _selectedCategory;
  List<dynamic> _categories = [];

   @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _addCategory() {
    final user = FirebaseAuth.instance.currentUser;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    String categoryIdString = const Uuid().v1();
    userDocRef.set(
      {
        'categories': FieldValue.arrayUnion([
          {'name': _categoryNameController.text, 'uid': categoryIdString, 'subcategories': []}
        ])
      },
      SetOptions(merge: true),
    );

    // Navigator.pushNamed(context, '/screenB');
    _categoryNameController.text = '';
    _categoryNameController.clear();
    _fetchCategories();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 40,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Add Category'),
            ),
            ListView.builder(
              itemCount: _categories.length,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                String individualObj = _categories[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(12.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        individualObj.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
