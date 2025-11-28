import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/products.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductItem.fromJson', () {
    test('parses numeric price and tags correctly', () {
      final json = {
        'id': '1',
        'name': 'Test Product',
        'description': 'A test',
        'price': 12.5,
        'discount': 2,
        'image': 'https://example.com/img.png',
        'catagory': 'Sales',
        'tags': ['a', 'b']
      };

      final p = ProductItem.fromJson(json);

      expect(p.id, '1');
      expect(p.name, 'Test Product');
      expect(p.description, 'A test');
      expect(p.price, 12.5);
      expect(p.discount, 2.0);
      expect(p.image, 'https://example.com/img.png');
      expect(p.category.toLowerCase(), 'sales');
      expect(p.tags, ['a', 'b']);
    });

    test('parses string price and missing fields safely', () {
      final json = {
        'name': 'Another',
        'price': '7.99',
        // missing discount, tags and image
      };

      final p = ProductItem.fromJson(json);

      expect(p.name, 'Another');
      expect(p.price, 7.99);
      expect(p.discount, 0.0);
      expect(p.tags, isEmpty);
      expect(p.image, '');
    });

    test('toJson round trips expected keys', () {
      final p = ProductItem(
          id: 'x',
          name: 'Round',
          description: 'desc',
          price: 2.0,
          image: '',
          category: 'cat',
          discount: 1.0,
          tags: ['t1']);

      final map = p.toJson();
      expect(map['name'], 'Round');
      expect(map['price'], 2.0);
      expect(map['tags'], ['t1']);
    });
  });
}
