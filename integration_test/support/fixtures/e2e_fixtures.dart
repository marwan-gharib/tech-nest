import 'package:tech_nest/core/constants/api_keys.dart';

const categories = [
  {ApiKeys.id: 1, ApiKeys.name: 'Laptops', ApiKeys.imgUrl: ''},
  {ApiKeys.id: 2, ApiKeys.name: 'Audio', ApiKeys.imgUrl: ''},
];

const products = [
  {
    ApiKeys.id: 1,
    ApiKeys.name: 'Aurora Laptop',
    ApiKeys.description: 'Fast laptop for work, study, and creative projects.',
    ApiKeys.price: 1299,
    ApiKeys.stock: 8,
    ApiKeys.category: {
      ApiKeys.id: 1,
      ApiKeys.name: 'Laptops',
      ApiKeys.imgUrl: '',
    },
    ApiKeys.imgUrl: '',
  },
  {
    ApiKeys.id: 2,
    ApiKeys.name: 'Pulse Headphones',
    ApiKeys.description: 'Wireless headphones with active noise cancellation.',
    ApiKeys.price: 249,
    ApiKeys.stock: 12,
    ApiKeys.category: {
      ApiKeys.id: 2,
      ApiKeys.name: 'Audio',
      ApiKeys.imgUrl: '',
    },
    ApiKeys.imgUrl: '',
  },
];

const orders = [
  {
    'id': 9001,
    'total_price': 1349,
    'status': 'confirmed',
    'created_at': '2026-05-30T10:00:00Z',
    'updated_at': '2026-05-30T10:05:00Z',
  },
];

Map<String, dynamic> orderDetails(int id) => {
  'id': id,
  'total_price': 1349,
  'status': 'confirmed',
  'shipping_address': '12 Nile Street, Cairo',
  'billing_address': '12 Nile Street, Cairo',
  'created_at': '2026-05-30T10:00:00Z',
  'updated_at': '2026-05-30T10:05:00Z',
  'items': [
    {
      'order_item_id': 1,
      'quantity': 1,
      'price': 1299,
      'product_id': 1,
      'name': 'Aurora Laptop',
      'image_url': '',
    },
  ],
};

final notifications = [
  {
    ApiKeys.id: 1,
    ApiKeys.title: 'Order confirmed',
    ApiKeys.body: 'Your order #9001 has been confirmed.',
    ApiKeys.type: ApiKeys.orderUpdate,
    ApiKeys.data: {ApiKeys.orderId: 9001},
    ApiKeys.createdAt: '2026-05-30T10:05:00Z',
    ApiKeys.isRead: 0,
  },
];
