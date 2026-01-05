import 'package:decimal/decimal.dart';

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

/// E-Commerce event for reporting to AppMetrica.
class AppMetricaECommerceEvent {
  static const String _showScreenEventType = "show_screen_event";
  static const String _showProductCardEventType = "show_product_card_event";
  static const String _showProductDetailsEventType = "show_product_details_event";
  static const String _addCartItemEventType = "add_cart_item_event";
  static const String _removeCartItemEventType = "remove_cart_item_event";
  static const String _beginCheckoutEventType = "begin_checkout_event";
  static const String _purchaseEventType = "purchase_event";

  final String _eventType;
  final AppMetricaECommerceCartItem? _cartItem;
  final AppMetricaECommerceOrder? _order;
  final AppMetricaECommerceProduct? _product;
  final AppMetricaECommerceReferrer? _referrer;
  final AppMetricaECommerceScreen? _screen;

  AppMetricaECommerceEvent._(this._eventType, this._cartItem, this._order,
      this._product, this._referrer, this._screen);

  AppMetricaECommerceEvent._showScreenEvent(AppMetricaECommerceScreen screen)
      : this._(_showScreenEventType, null, null, null, null, screen);

  AppMetricaECommerceEvent._showProductCardEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceScreen screen)
      : this._(_showProductCardEventType, null, null, product, null, screen);

  AppMetricaECommerceEvent._showProductDetailsEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceReferrer? referrer)
      : this._(_showProductDetailsEventType, null, null, product, referrer, null);

  AppMetricaECommerceEvent._addCartItemEvent(AppMetricaECommerceCartItem cartItem)
      : this._(_addCartItemEventType, cartItem, null, null, null, null);

  AppMetricaECommerceEvent._removeCartItemEvent(AppMetricaECommerceCartItem cartItem)
      : this._(_removeCartItemEventType, cartItem, null, null, null, null);

  AppMetricaECommerceEvent._beginCheckoutEvent(AppMetricaECommerceOrder order)
      : this._(_beginCheckoutEventType, null, order, null, null, null);

  AppMetricaECommerceEvent._purchaseEvent(AppMetricaECommerceOrder order)
      : this._(_purchaseEventType, null, order, null, null, null);

  /// Event type identifier. Used by converters.
  String get eventType => _eventType;

  /// Cart item for cart events. Used by converters.
  AppMetricaECommerceCartItem? get cartItem => _cartItem;

  /// Order for checkout/purchase events. Used by converters.
  AppMetricaECommerceOrder? get order => _order;

  /// Product for product-related events. Used by converters.
  AppMetricaECommerceProduct? get product => _product;

  /// Referrer for product details events. Used by converters.
  AppMetricaECommerceReferrer? get referrer => _referrer;

  /// Screen for screen/product card events. Used by converters.
  AppMetricaECommerceScreen? get screen => _screen;
}

/// Class for creating E-Commerce events of various types.
class AppMetricaECommerce {
  AppMetricaECommerce._();

  /// Creates E-Commerce ShowScreenEvent events.
  ///
  /// Use it to inform about the opening of a page, for example: a list of products, a search, the main page.
  static AppMetricaECommerceEvent showScreenEvent(AppMetricaECommerceScreen screen) {
    return AppMetricaECommerceEvent._showScreenEvent(screen);
  }

  /// Creates an E-Commerce event ShowProductCardEvent.
  ///
  /// Use it to report the viewing of the product card among others in the list.
  static AppMetricaECommerceEvent showProductCardEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceScreen screen) {
    return AppMetricaECommerceEvent._showProductCardEvent(product, screen);
  }

  /// Creates an E-Commerce event ShowProductDetailsEvent.
  ///
  /// Use it to report a product page view.
  static AppMetricaECommerceEvent showProductDetailsEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceReferrer? referrer) {
    return AppMetricaECommerceEvent._showProductDetailsEvent(product, referrer);
  }

  /// Creates an E-Commerce event AddCartItemEvent.
  ///
  /// Use it to inform about the addition of an item to the cart.
  static AppMetricaECommerceEvent addCartItemEvent(AppMetricaECommerceCartItem cartItem) {
    return AppMetricaECommerceEvent._addCartItemEvent(cartItem);
  }

  /// Creates E-Commerce RemoveCartItemEvent events.
  ///
  /// Use it to report the removal of an item from the cart.
  static AppMetricaECommerceEvent removeCartItemEvent(AppMetricaECommerceCartItem cartItem) {
    return AppMetricaECommerceEvent._removeCartItemEvent(cartItem);
  }

  /// Creates E-Commerce events BeginCheckoutEvent.
  ///
  /// Use it to inform about the start of the purchase.
  static AppMetricaECommerceEvent beginCheckoutEvent(AppMetricaECommerceOrder order) {
    return AppMetricaECommerceEvent._beginCheckoutEvent(order);
  }

  /// Creates E-Commerce PurchaseEvent events.
  ///
  /// Use it to inform about the completion of the purchase.
  static AppMetricaECommerceEvent purchaseEvent(AppMetricaECommerceOrder order) {
    return AppMetricaECommerceEvent._purchaseEvent(order);
  }
}
