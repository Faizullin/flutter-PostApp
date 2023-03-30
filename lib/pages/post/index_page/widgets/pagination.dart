import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/post_service.dart';

class Pagination extends StatelessWidget {
  final int _totalPages = 10;
  final PostService postService;
  const Pagination({
    super.key,
    required this.postService,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (index) {
        final pageIndex = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            onPressed: () {
              postService.setPage(pageIndex);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return postService.currentPage == pageIndex ? ColorConstant.teal600 : null;
              }),
            ),
            child: Text('$pageIndex'),
          ),
        );
      }),
    );
  }
}