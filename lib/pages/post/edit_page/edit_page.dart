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
import 'package:post_app/models/post.dart';
import 'package:post_app/models/tag.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/widgets/app_bar/appbar_title.dart';
import 'package:post_app/widgets/app_bar/custom_app_bar.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';
import 'package:provider/provider.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class InputBlock extends StatelessWidget {
  final Widget child;
  const InputBlock({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: child,
    );
  }
}


class PostEditPage extends StatefulWidget {
  final String id;
  final String title;
  const PostEditPage({Key? key,required this.id,required this.title,}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPage();
}


class _PostEditPage extends State<PostEditPage> {
  final _formKey = GlobalKey<FormState>();
  final PostService postService = PostService();
  late Future<Filters> futureFilters = postService.getAllFilters();
  late Future<Post> futurePost;


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

  setPostValues(Post post){
    titleController.text = post.title;
    descriptionController.text = post.description;
    selectedCategoryValue = post.category?.id.toString();
  }

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
        child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshotPost) {
            if(snapshotPost.hasData){
              setPostValues(snapshotPost.data!);
              return Column(
                children: [
                  InputBlock(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                  (!showFeatureImage) ? InputBlock(
                    child: ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Choose from gallery'),
                      onTap: () {
                        _uploadImage(crop:true);
                      },
                    ),
                  ) : InputBlock(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from gallery'),
                            onTap: () {
                              _uploadImage(crop:true);
                            },
                          ),
                          SizedBox(height: getVerticalSize(10),),
                          _image(),
                        ],
                      )
                  ),


                  FutureBuilder<Filters>(
                    future: futureFilters,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<int> selectedTagIds = snapshot.data!.tags.map<int>((tag) => tag.id).toList();
                        selectedTagValues = snapshot.data!.tags.where((tag) => selectedTagIds.contains(tag.id)).toList();
                        return Column(
                          children: [
                            InputBlock(
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
                                initialValue: selectedTagValues,
                                items: snapshot.data!.tags.map((tag) => MultiSelectItem<Tag>(tag, tag.title)) .toList(),
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
                            InputBlock(
                              child: Column(
                                children: [
                                  QuillToolbar.basic(controller: bodyController),
                                  QuillEditor.basic(
                                    controller: bodyController,
                                    readOnly: false,
                                  ),
                                ],
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
                ],
              );
            } else if (snapshotPost.hasError){
              return Text("Error ${snapshotPost.error}");
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    futurePost = postService.getPostById(widget.id,auth.token);

    if (!auth.isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.authLogin);
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
            title: AppbarTitle(text: widget.title , margin: getMargin(left: 22)),
            actions: [
              TextButton(
                onPressed: () => _save(auth.token),
                child: Text(
                  'Update',
                  style: AppStyle.txtInterMedium20.copyWith(
                      color: ColorConstant.whiteA700
                  ),
                ),
              ),
            ]
        ),
        drawer: const SidebarDrawer(),

        body: _buildAuth(),
      ),
    );
  }

  void _save(String token) async {

    if (_formKey.currentState!.validate()) {
      final bodyConverter = QuillDeltaToHtmlConverter(
        List.castFrom(bodyController.document.toDelta().toJson()),
        ConverterOptions.forEmail(),
      );
      postService.store(
        {
          'title': titleController.text,
          'description': descriptionController.text,
          'category': selectedCategoryValue,
          'tags': selectedTagValues.map((e) => e.id.toString()).toList(),
          'image': _croppedImageFile ?? _pickedImageFile,
          'body': bodyConverter.convert(),
        },
        token,
      );
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
            lockAspectRatio: false),
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
