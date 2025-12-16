import 'package:flutter/material.dart';
import 'package:mycargenie_2/theme/icons.dart';

class FocusableDropdown extends StatelessWidget {
  final String name;
  final MenuController menuController;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final String? selectedItem;

  const FocusableDropdown({
    super.key,
    required this.name,
    required this.menuController,
    required this.items,
    required this.onSelected,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: menuController,
      builder: (context, controller, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                alignment: AlignmentGeometry.directional(-0.9, 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedItem ?? name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    controller.isOpen ? arrowUpIcon() : arrowDownIcon(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      menuChildren: [
        for (var item in items)
          MenuItemButton(onPressed: () => onSelected(item), child: Text(item)),
      ],
    );
  }
}
