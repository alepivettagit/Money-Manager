import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager/models/category_item.dart';

void main() {
  test('CategoryItem test and serialization', () {
    const item = CategoryItem(
      name: 'Spesa e Cibo',
      icon: Icons.shopping_basket_rounded,
      color: Color(0xFF10B981),
    );

    final map = item.toMap();
    final restored = CategoryItem.fromMap(map);

    expect(restored.name, 'Spesa e Cibo');
    expect(restored.icon.codePoint, item.icon.codePoint);
    expect(restored.color.toARGB32(), item.color.toARGB32());
  });
}
