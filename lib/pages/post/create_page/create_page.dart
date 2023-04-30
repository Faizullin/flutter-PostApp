import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/category.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/tag.dart';
import 'package:post_app/pages/auth/login_page.dart';
import 'package:post_app/pages/post/create_page/widgets/input_block.dart';
import 'package:post_app/pages/post/index_page/index_page.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/widgets/app_bar/appbar_title.dart';
import 'package:post_app/widgets/app_bar/custom_app_bar.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';
import 'package:provider/provider.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  @override
  State<PostCreatePage> createState() => _PostCreatePage();
}


class _PostCreatePage extends State<PostCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final PostService postService = PostService();
  late Future<Filters> futureFilters = postService.getAllFilters();
  late Map<String,dynamic> _errors = {};

  bool showFeatureImage = false;
  XFile? _pickedImageFile;
  CroppedFile? _croppedImageFile;

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
  QuillController bodyController = QuillController.basic();

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedImageFile != null) {
      final path = _croppedImageFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedImageFile != null) {
      final path = _pickedImageFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildAuth() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputBlock(
                labelText: 'Title',
                error: _errors['title']?.first ?? '',
                child: TextField(
                  controller: titleController,
                ),
              ),
              InputBlock(
                labelText: 'Description',
                error: _errors['description']?.first ?? '',
                child: TextField(
                  controller: descriptionController,
                ),
              ),
              (!showFeatureImage) ? InputBlock(
                labelText: 'Logo image',
                error: _errors['image']?.first ?? '',
                child: ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    _uploadImage(crop:true);
                  },
                ),
              ) : InputBlock(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Choose from gallery'),
                    onTap: () {
                      _uploadImage(crop:true);
                    },
                  ),
                  SizedBox(height: getVerticalSize(8),),
                  ErrorText(_errors['image']?.first ?? '',),
                  SizedBox(height: getVerticalSize(10),),
                  _image(),
                ],
              ),
              FutureBuilder<Filters>(
                future: futureFilters,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        InputBlock(
                          error: _errors['category']?.first ?? '',
                          child: Row(
                            children: [
                              const Text('Category'),
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownButton(
                                items: snapshot.data!.categories
                                    .map<DropdownMenuItem<String>>((
                                    Category category) {
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
                          error: _errors['tags']?.first ?? '',
                          child: MultiSelectDialogField<Tag>(
                            key: _multiSelectKey,
                            onConfirm: (values) {
                              setState(() {
                                selectedTagValues = values;
                              });
                            },
                            searchable: true,
                            listType: MultiSelectListType.CHIP,
                            dialogWidth: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            items: snapshot.data!.tags
                                .map((tag) =>
                                MultiSelectItem<Tag>(tag, tag.title))
                                .toList(),
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
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [CircularProgressIndicator()],
                  );
                },
              ),
              SizedBox(
                height: getVerticalSize(3),
              ),
              InputBlock(
                children: [
                  const Text('Body'),
                  QuillToolbar.basic(controller: bodyController),
                  QuillEditor.basic(
                    controller: bodyController,
                    readOnly: false,
                  ),
                  ErrorText(_errors['body']?.first ?? '',),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAuthenticated) {
      return const LoginPage();
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          height: getVerticalSize(56.00),
          leadingWidth: 42,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: AppbarTitle(text: "Create Post", margin: getMargin(left: 22)),
          actions: [
            TextButton(
              onPressed: () => _save(auth.token),
              child: Text(
                'Save',
                style: AppStyle.txtInterMedium20.copyWith(
                  color: ColorConstant.whiteA700
                ),
              ),
            ),
          ],
        ),
        drawer: const SidebarDrawer(
          currentIndex: AppRoutes.postCreate,
        ),

        body: _buildAuth(),
      ),
    );
  }

  void _save(String token) async {
    final deltaJson = bodyController.document.toDelta().toJson();
    final bodyConverter = QuillDeltaToHtmlConverter(
      List.castFrom(deltaJson),
      ConverterOptions.forEmail(),
    );
    if (_formKey.currentState!.validate()) {
      postService.store({
          'title': titleController.text,
          'description': descriptionController.text,
          'category': selectedCategoryValue,
          'tags[]': jsonEncode(selectedTagValues.map((e) => e.id.toInt()).toList()),//.join(','),
          'image': _croppedImageFile ?? _pickedImageFile,
          'body': bodyConverter.convert(),
        },
        token,
      ).then((Map<String, dynamic> result ) {
        if(result['success'] == false) {
          setState(() {
            if (result.containsKey('errors')) {
              _errors = result['errors'];
            } else if (result.containsKey('errorMessage')) {
              // _errorMessage = result['errorMessage'];
            }
          });
        } else {
          _errors.clear();
          // _errorMessage = '';
          Navigator.pushNamed(context, AppRoutes.postIndex,arguments: PostIndexArguments(
            selectedFilters: SelectFilters(
              categories: [],
              tags: [],
              sortColumn: 'my',
            ),
          ));
        }
      });
    }
  }


  _cropImage(XFile pickedImageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: ColorConstant.deepOrange400,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: CroppieBoundary(
            width: getHorizontalSize(200).toInt(),
            height: getVerticalSize(200).toInt(),
          ),
          viewPort: CroppieViewPort(
            width: getHorizontalSize(170).toInt(),
            height: getHorizontalSize(170).toInt(),
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedFile != null) {

      setState(() {
        _croppedImageFile = croppedFile;
        showFeatureImage = true;
      });
    }
  }

  Future<void> _uploadImage({bool crop = false, ImageSource source = ImageSource.gallery}) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      if(crop){
        await _cropImage(pickedFile);
      } else {
        setState(() {
          _pickedImageFile = pickedFile;
          showFeatureImage = true;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
