import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:post_app/models/category.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_app/models/tag.dart';
import 'package:post_app/services/api_post.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class InputBlock extends StatelessWidget {
  final Widget child;
  const InputBlock({super.key, required this.child,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: child,
    );
  }
}

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  @override
  State<PostCreatePage> createState() => _PostCreatePage();
}

QuillController bodyController = QuillController.basic();

class _PostCreatePage extends State<PostCreatePage> {
  final _formKey = GlobalKey<FormState>();


  File? image;
  String? base64Image;
  bool? showFeatureImage = false;
  Image? featureImage;



  String? title;
  String? body;
  String? description;
  int? postCategory;
  List<Category> categories = [];
  List<Tag> tags = [];
  List<Tag> selectedTagValues = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  String? selectedCategoryValue;


  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController categoryController = TextEditingController();
  // final TextEditingController tagsController = TextEditingController();

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      image = File(photo.path.toString());
      List<int> imageBytes = File(photo.path.toString()).readAsBytesSync();
      base64Image = base64Encode(imageBytes);

      setState(() {
        showFeatureImage = !showFeatureImage!;
        featureImage = Image.memory(base64Decode(base64Image!));
      });
    } else {
      // User canceled the picker
    }
  }



  @override
  void initState() {
    super.initState();
    _getFilters();
  }

  _getFilters() async {
    Map<String,dynamic> filters = await fetchGetFilters();
    List<dynamic> rawFilterCategories = filters['categories'];
    List<dynamic> rawFilterTags = filters['tags'];
    setState(() {
      categories = rawFilterCategories.map((item) => Category.fromJson(item)).toList();
      tags = rawFilterTags.map((item) => Tag.fromJson(item)).toList();
    });
  }

  String quillDeltaToHtml(Delta delta) {
    final convertedValue = delta.toJson() as List<Map<String,dynamic>>;
    final converter = QuillDeltaToHtmlConverter(convertedValue);
   return converter.convert();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //UserCredential userProfile = Provider.of<UserProfile>(context).user;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context,'/post');
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://user-images.githubusercontent.com/10923085/119221946-2de89000-baf2-11eb-8285-68168a78c658.png'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                InputBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      const Text('Title'),
                      TextField(
                        controller: titleController,
                      ),
                    ],
                  ),
                ),
                InputBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description'),
                      TextField(
                        controller: descriptionController,
                      ),
                    ],
                  ),
                ),
                InputBlock(
                  child: QuillToolbar.basic(
                    controller: bodyController,
                  ),
                ),
                InputBlock(
                  //padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightBlueAccent,
                            offset: Offset(5.0, 5.0)    ,
                            blurRadius: 10.0,
                            spreadRadius: 2.0
                          ),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0
                          )
                        ]
                    ),
                    child: QuillEditor.basic(
                      controller: bodyController,
                      readOnly: false
                    ),
                  ),
                ),
                InputBlock(
                  child: Row(
                    children: [
                      const Text('Category'),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        items: categories.map<DropdownMenuItem<String>>((Category category) {
                          return DropdownMenuItem(
                            value: '${category.id}',
                            child: Text(category.title),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategoryValue = value;
                          });
                        },
                        value: selectedCategoryValue,
                      ),
                    ],
                  ),
                ),
                InputBlock(
                  child: MultiSelectDialogField<Tag>(
                    key: _multiSelectKey,
                    onConfirm: (values) {
                      setState(() {
                        selectedTagValues = values;
                      });
                    },
                    searchable: true,
                    listType: MultiSelectListType.CHIP,
                    dialogWidth: MediaQuery.of(context).size.width * 0.7,
                    items: tags.map((tag) => MultiSelectItem<Tag>(tag, tag.title)).toList(),
                    chipDisplay: MultiSelectChipDisplay(
                      onTap: (item) {
                        setState(() {
                          selectedTagValues.remove(item);
                        });
                        _multiSelectKey.currentState!.validate();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: _save,
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    await fetchStorePost({
      'title': titleController.text ?? '',
      'description': descriptionController.text ?? '',
      'category': selectedCategoryValue ,
      'tags': selectedTagValues.map((e) => e.id.toString()).toList(),
      'body': quillDeltaToHtml(bodyController.document.toDelta()),
    });
  }
}