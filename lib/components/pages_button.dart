import 'package:flutter/material.dart';

class PagesButton extends StatelessWidget {
  const PagesButton({
    super.key,
    required this.pageNumber,
    required this.currentPage,
    required this.onPressed,
  });

  final int pageNumber;
  final int currentPage;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      style: TextButton.styleFrom(
        backgroundColor: pageNumber == currentPage ? Theme.of(context).primaryColor : Colors.grey,
        minimumSize: const Size(40, 40),
      ),
      child: Text(
        '$pageNumber',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class PagesButtons extends StatelessWidget {
  const PagesButtons({
    super.key,
    required this.totalItems,
    required this.itemsPerPage,
    required this.currentPage,
    required this.onPageChanged,
  });

  final int totalItems;
  final int itemsPerPage;
  final int currentPage;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    final pageCount = (totalItems / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: PagesButton(
            pageNumber: index + 1,
            currentPage: currentPage,
            onPressed: () {
              onPageChanged(index + 1);
            },
          ),
        ),
      ),
    );
  }
}
