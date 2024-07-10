import 'package:decimal/decimal.dart';

import 'ecommerce_event.dart';

/// Class with cost information. You can set:
/// * [amount] - quantity of goods, numeric value;
/// * [currency] — units of measurement.
class AppMetricaECommerceAmount {
  final Decimal amount;
  final String currency;

  /// Creates an object with cost information. All parameters are required.
  const AppMetricaECommerceAmount({required this.amount, required this.currency});
}

/// Class with information about the product:
/// * [sku] — the article of the product. The allowed size is up to 100 characters.
/// * [name] — the name of the product. The allowed size is up to 1000 characters.
/// * [categoriesPath] - the path to the product by category. Acceptable sizes are up to 10 elements; the size of one element is up to 100 characters.
/// * [payload] - additional information about the product. Acceptable sizes: total payload size - up to 20 KB, key size - up to 100 characters, value size - up to 1000 characters;
/// * [actualPrice] — the actual price of the product. Price after applying all discounts and promo codes;
/// * [originalPrice] — the initial price of the product;
/// * [promocodes] - a list of promo codes that apply to the product. Acceptable sizes — up to 20 elements; promo code length - up to 100 characters.
class AppMetricaECommerceProduct {
  final String sku;
  final String? name;
  final List<String>? categoriesPath;
  final Map<String, String>? payload;
  final AppMetricaECommercePrice? actualPrice;
  final AppMetricaECommercePrice? originalPrice;
  final List<String>? promocodes;

  /// Creates an object with information about the product. [sku] is a required parameter.
  const AppMetricaECommerceProduct(
      {required this.sku,
      this.name,
      this.categoriesPath,
      this.payload,
      this.actualPrice,
      this.originalPrice,
      this.promocodes});
}

/// Class with information about the price of the product:
/// * [fiat] - the cost in fiat money (an object of the [AppMetricaECommerceAmount] class);
/// * [internalComponents] — the cost of internal components (amounts in internal currency). The allowed size for internal Components is up to 30 elements.
class AppMetricaECommercePrice {
  final AppMetricaECommerceAmount fiat;
  final List<AppMetricaECommerceAmount>? internalComponents;

  /// Creates an object with information about the price of the product. [fiat] is a required parameter.
  const AppMetricaECommercePrice({required this.fiat, this.internalComponents});
}

/// Class with information about the transition source:
/// * [type] — type of the transition source. The maximum length is up to 100 characters;
/// * [identifier] - the identifier of the transition source. Maximum length - up to 2048 characters;
/// * [screen] - transition source screen.
class AppMetricaECommerceReferrer {
  final String? type;
  final String? identifier;
  final AppMetricaECommerceScreen? screen;

  /// Creates an object with information about the transition source.
  const AppMetricaECommerceReferrer({this.type, this.identifier, this.screen});
}

/// Class with information about the screen:
/// * [name] — the name of the screen;
/// * [categoriesPath] - the path to the screen by category. Maximum size - up to 10 elements;
/// * [searchQuery] - search query. Maximum length - up to 1000 characters;
/// * [payload] - additional information. The maximum size is 20 KB.
class AppMetricaECommerceScreen {
  final String? name;
  final List<String>? categoriesPath;
  final String? searchQuery;
  final Map<String, String>? payload;

  /// Creates an object with information about the screen.
  const AppMetricaECommerceScreen(
      {this.name, this.categoriesPath, this.searchQuery, this.payload});
}

/// Class with information about the product in the cart:
/// * [product] - product;
/// * [quantity] - quantity of the product, numeric value;
/// * [revenue] — the total price of the product in the basket;
/// * [referrer] — the source of the transition to the basket.
class AppMetricaECommerceCartItem {
  final AppMetricaECommerceProduct product;
  final Decimal quantity;
  final AppMetricaECommercePrice revenue;
  final AppMetricaECommerceReferrer? referrer;

  /// Creates an object with information about the product in the cart. The parameters [product], [quantity], [revenue] are required.
  const AppMetricaECommerceCartItem(
      {required this.product,
      required this.quantity,
      required this.revenue,
      this.referrer});
}

/// Class with order information:
/// * [identifier] - order ID.  Maximum length - up to 100 characters;
/// * [items] - list of products in the cart;
/// * [payload] - additional information about the order. The maximum size is 20 KB.
class AppMetricaECommerceOrder {
  final String identifier;
  final List<AppMetricaECommerceCartItem> items;
  final Map<String, String>? payload;

  /// Creates an object with order information. The parameters [identifier], [items] are required.
  const AppMetricaECommerceOrder(
      {required this.identifier, required this.items, this.payload});
}

/// Class for creating E-Commerce events of various types.
class AppMetricaECommerce {
  AppMetricaECommerce._();

  /// Creates E-Commerce ShowScreenEvent events.
  ///
  /// Use it to inform about the opening of a page, for example: a list of products, a search, the main page.
  static AppMetricaECommerceEvent showScreenEvent(AppMetricaECommerceScreen screen) {
    return ECommerceConstructors.showScreenEvent(screen);
  }

  /// Creates an E-Commerce event ShowProductCardEvent.
  ///
  /// Use it to report the viewing of the product card among others in the list.
  static AppMetricaECommerceEvent showProductCardEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceScreen screen) {
    return ECommerceConstructors.showProductCardEvent(product, screen);
  }

  /// Creates an E-Commerce event ShowProductDetailsEvent.
  ///
  /// Use it to report a product page view.
  static AppMetricaECommerceEvent showProductDetailsEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceReferrer? referrer) {
    return ECommerceConstructors.showProductDetailsEvent(product, referrer);
  }

  /// Creates an E-Commerce event AddCartItemEvent.
  ///
  /// Use it to inform about the addition of an item to the cart.
  static AppMetricaECommerceEvent addCartItemEvent(AppMetricaECommerceCartItem cartItem) {
    return ECommerceConstructors.addCartItemEvent(cartItem);
  }

  /// Creates E-Commerce RemoveCartItemEvent events.

  /// Use it to report the removal of an item from the cart.
  static AppMetricaECommerceEvent removeCartItemEvent(AppMetricaECommerceCartItem cartItem) {
    return ECommerceConstructors.removeCartItemEvent(cartItem);
  }

  /// Creates E-Commerce events BeginCheckoutEvent.

  /// Use it to inform about the start of the purchase.
  static AppMetricaECommerceEvent beginCheckoutEvent(AppMetricaECommerceOrder order) {
    return ECommerceConstructors.beginCheckoutEvent(order);
  }

  /// Creates E-Commerce PurchaseEvent events.

  /// Use it to inform about the completion of the purchase.
  static AppMetricaECommerceEvent purchaseEvent(AppMetricaECommerceOrder order) {
    return ECommerceConstructors.purchaseEvent(order);
  }
}
