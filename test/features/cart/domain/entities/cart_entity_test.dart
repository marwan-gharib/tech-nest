import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

void main() {
  const tProduct1 = ProductEntity(
    id: 1,
    name: 'Product 1',
    description: 'Desc',
    price: 1000.0,
    stock: 10,
    category: CategoryEntity.empty(),
    imgUrl: 'img.jpg',
  );

  const tProduct2 = ProductEntity(
    id: 2,
    name: 'Product 2',
    description: 'Desc',
    price: 2000.0,
    stock: 10,
    category: CategoryEntity.empty(),
    imgUrl: 'img.jpg',
  );

  final tCartItem1 = CartItem(id: 1, quantity: 2, product: tProduct1);
  final tCartItem2 = CartItem(id: 2, quantity: 1, product: tProduct2);

  group('CartEntity recalculate', () {
    test(
      'should calculate total quantity, prices and free delivery correctly',
      () {
        final cart = Cart(
          items: [],
          totalQuantity: 0,
          totalPrice: 0,
          deliveryCharges: 0,
          grandTotal: 0,
        );

        final newItems = [tCartItem1, tCartItem2];
        final updatedCart = cart.recalculate(newItems);

        expect(updatedCart.items, newItems);
        expect(updatedCart.totalQuantity, 3);
        expect(updatedCart.totalPrice, 4000);
        expect(updatedCart.deliveryCharges, 0);
        expect(updatedCart.grandTotal, 4000);
      },
    );

    test(
      'should calculate with default delivery charges when total price is below threshold',
      () {
        final cart = Cart(
          items: [],
          totalQuantity: 0,
          totalPrice: 0,
          deliveryCharges: 0,
          grandTotal: 0,
        );

        final newItems = [CartItem(id: 3, quantity: 1, product: tProduct1)];
        final updatedCart = cart.recalculate(newItems);

        expect(updatedCart.items, newItems);
        expect(updatedCart.totalQuantity, 1);
        expect(updatedCart.totalPrice, 1000);
        expect(updatedCart.deliveryCharges, 50);
        expect(updatedCart.grandTotal, 1050);
      },
    );

    test('should set delivery charges to 0 when cart is empty', () {
      final cart = Cart(
        items: [tCartItem1],
        totalQuantity: 2,
        totalPrice: 2000,
        deliveryCharges: 0,
        grandTotal: 2000,
      );

      final updatedCart = cart.recalculate([]);

      expect(updatedCart.items, []);
      expect(updatedCart.totalQuantity, 0);
      expect(updatedCart.totalPrice, 0);
      expect(updatedCart.deliveryCharges, 0);
      expect(updatedCart.grandTotal, 0);
    });
  });

  group('CartEntity copyWith', () {
    test('should return a new instance with updated values', () {
      final cart = Cart(
        items: [],
        totalQuantity: 0,
        totalPrice: 0,
        deliveryCharges: 0,
        grandTotal: 0,
      );

      final newCart = cart.copyWith(totalQuantity: 1, totalPrice: 100);

      expect(newCart.totalQuantity, 1);
      expect(newCart.totalPrice, 100);
      expect(newCart.deliveryCharges, 0);
    });
  });
}
