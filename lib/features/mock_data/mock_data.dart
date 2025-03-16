class MockData {
  static List<RestaurantData> restaurantData = [
    RestaurantData(logo: 'assets/image/restaurant.png', name: 'Restaurant'),
    RestaurantData(logo: 'assets/image/flower.png', name: 'Flowers'),
    RestaurantData(logo: 'assets/image/grocery.png', name: 'Groceries'),
    RestaurantData(logo: 'assets/image/pharmacy.png', name: 'Pharmacies'),
    RestaurantData(logo: 'assets/image/healthy_food.png', name: 'Healthy Food'),
    RestaurantData(logo: 'assets/image/coffee.png', name: 'Coffee & Daunts'),
  ];

  static List<SubCategoryItem> mockRestaurantData = [
    SubCategoryItem(
      image: 'https://stackfood-admin.6amtech.com/storage/app/public/restaurant/2021-08-20-611fc6cd6b011.png',
      title: 'Hungry Puppets',
      rating: '4.7',
      deliveryTime: '30-40 mins',
      deliveryCharge: 'Free',
      availableBonus: 'Free Drink',
    ),
    SubCategoryItem(
      image: 'https://stackfood-admin.6amtech.com/storage/app/public/restaurant/2021-08-20-611fc4cd9c598.png',
      title: 'Café Monarch',
      rating: '5.0',
      deliveryTime: '30-40 mins',
      deliveryCharge: 'Free',
      availableBonus: 'Buy 1 Get 1',
    ),
    SubCategoryItem(
      image: 'https://stackfood-admin.6amtech.com/storage/app/public/restaurant/2021-08-20-611fc9b200e8c.png',
      title: 'Cheese Burger',
      rating: '5.0',
      deliveryTime: '30-40 mins',
      deliveryCharge: 'Free',
      availableBonus: '20% Off',
    ),
    SubCategoryItem(
      image: 'https://stackfood-admin.6amtech.com/storage/app/public/restaurant/2021-08-21-612008a117429.png',
      title: 'Vintage Kitchen',
      rating: '4.7',
      deliveryTime: '30-40 mins',
      deliveryCharge: 'Free',
      availableBonus: '50% off',
    ),
    SubCategoryItem(
      image: 'https://stackfood-admin.6amtech.com/storage/app/public/restaurant/2021-08-21-612009adefa47.png',
      title: 'The Capital Grill',
      rating: '0.0',
      deliveryTime: '20-25 mins',
      deliveryCharge: '\$3',
      availableBonus: '15% Off',
    ),
  ];

}

class RestaurantData {
  final String logo;
  final String name;

  RestaurantData({required this.logo, required this.name});
}

class SubCategoryItem {
  final String image;
  final String title;
  final String rating; //4.5
  final String deliveryTime; // 20 mins
  final String deliveryCharge; // Free, 20$
  final String availableBonus;

  SubCategoryItem(
      {required this.image,
      required this.title,
      required this.rating,
      required this.deliveryTime,
      required this.deliveryCharge,
      required this.availableBonus});
}