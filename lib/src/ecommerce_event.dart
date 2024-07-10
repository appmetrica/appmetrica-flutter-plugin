import 'ecommerce.dart';
import 'appmetrica_api_pigeon.dart';

class AppMetricaECommerceEvent {
  static const String _showScreenEventType = "show_screen_event";
  static const String _showProductCardEventType = "show_product_card_event";
  static const String _showProductDetailsEventType =
      "show_product_details_event";
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

  AppMetricaECommerceEvent._(this._eventType, this._cartItem, this._order, this._product,
      this._referrer, this._screen);

  AppMetricaECommerceEvent._showScreenEvent(AppMetricaECommerceScreen screen)
      : this._(_showScreenEventType, null, null, null, null, screen);

  AppMetricaECommerceEvent._showProductCardEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceScreen screen)
      : this._(_showProductCardEventType, null, null, product, null, screen);

  AppMetricaECommerceEvent._showProductDetailsEvent(
      AppMetricaECommerceProduct product, AppMetricaECommerceReferrer? referrer)
      : this._(
            _showProductDetailsEventType, null, null, product, referrer, null);

  AppMetricaECommerceEvent._addCartItemEvent(AppMetricaECommerceCartItem cartItem)
      : this._(_addCartItemEventType, cartItem, null, null, null, null);

  AppMetricaECommerceEvent._removeCartItemEvent(AppMetricaECommerceCartItem cartItem)
      : this._(_removeCartItemEventType, cartItem, null, null, null, null);

  AppMetricaECommerceEvent._beginCheckoutEvent(AppMetricaECommerceOrder order)
      : this._(_beginCheckoutEventType, null, order, null, null, null);

  AppMetricaECommerceEvent._purchaseEvent(AppMetricaECommerceOrder order)
      : this._(_purchaseEventType, null, order, null, null, null);
}

class ECommerceConstructors {
  ECommerceConstructors._();

  static AppMetricaECommerceEvent showScreenEvent(AppMetricaECommerceScreen screen) =>
      AppMetricaECommerceEvent._showScreenEvent(screen);

  static AppMetricaECommerceEvent showProductCardEvent(
          AppMetricaECommerceProduct product, AppMetricaECommerceScreen screen) =>
      AppMetricaECommerceEvent._showProductCardEvent(product, screen);

  static AppMetricaECommerceEvent showProductDetailsEvent(
          AppMetricaECommerceProduct product, AppMetricaECommerceReferrer? referrer) =>
      AppMetricaECommerceEvent._showProductDetailsEvent(product, referrer);

  static AppMetricaECommerceEvent addCartItemEvent(AppMetricaECommerceCartItem cartItem) =>
      AppMetricaECommerceEvent._addCartItemEvent(cartItem);

  static AppMetricaECommerceEvent removeCartItemEvent(AppMetricaECommerceCartItem cartItem) =>
      AppMetricaECommerceEvent._removeCartItemEvent(cartItem);

  static AppMetricaECommerceEvent beginCheckoutEvent(AppMetricaECommerceOrder order) =>
      AppMetricaECommerceEvent._beginCheckoutEvent(order);

  static AppMetricaECommerceEvent purchaseEvent(AppMetricaECommerceOrder order) =>
      AppMetricaECommerceEvent._purchaseEvent(order);
}

extension ECommerceConverter on AppMetricaECommerceEvent {
  ECommerceEventPigeon toPigeon() => _findConverter(AppMetricaECommerceEvent)(this);
}

extension ECommerceScreenConverter on AppMetricaECommerceScreen {
  ECommerceScreenPigeon toPigeon() => _findConverter(AppMetricaECommerceScreen)(this);
}

extension ECommerceProductConverter on AppMetricaECommerceProduct {
  ECommerceProductPigeon toPigeon() => _findConverter(AppMetricaECommerceProduct)(this);
}

extension ECommerceReferrerConverter on AppMetricaECommerceReferrer {
  ECommerceReferrerPigeon toPigeon() => _findConverter(AppMetricaECommerceReferrer)(this);
}

extension ECommerceCartItemConverter on AppMetricaECommerceCartItem {
  ECommerceCartItemPigeon toPigeon() => _findConverter(AppMetricaECommerceCartItem)(this);
}

extension ECommerceOrderConverter on AppMetricaECommerceOrder {
  ECommerceOrderPigeon toPigeon() => _findConverter(AppMetricaECommerceOrder)(this);
}

extension ECommerceAmountConverter on AppMetricaECommerceAmount {
  ECommerceAmountPigeon toPigeon() => _findConverter(AppMetricaECommerceAmount)(this);
}

extension ECommercePriceConverter on AppMetricaECommercePrice {
  ECommercePricePigeon toPigeon() => _findConverter(AppMetricaECommercePrice)(this);
}

Function _findConverter<I, O>(type) => eCommerceConverters[type]!;

final eCommerceConverters = <Type, Function>{
  AppMetricaECommerceEvent: (AppMetricaECommerceEvent event) => ECommerceEventPigeon(
      eventType: event._eventType,
      cartItem: event._cartItem?.toPigeon(),
      order: event._order?.toPigeon(),
      product: event._product?.toPigeon(),
      referrer: event._referrer?.toPigeon(),
      screen: event._screen?.toPigeon()),
  AppMetricaECommerceScreen: (AppMetricaECommerceScreen screen) => ECommerceScreenPigeon(
      name: screen.name,
      categoriesPath: screen.categoriesPath,
      searchQuery: screen.searchQuery,
      payload: screen.payload),
  AppMetricaECommerceProduct: (AppMetricaECommerceProduct product) => ECommerceProductPigeon(
      sku: product.sku,
      name: product.name,
      categoriesPath: product.categoriesPath,
      payload: product.payload,
      actualPrice: product.actualPrice?.toPigeon(),
      originalPrice: product.originalPrice?.toPigeon(),
      promocodes: product.promocodes),
  AppMetricaECommerceReferrer: (AppMetricaECommerceReferrer referrer) => ECommerceReferrerPigeon(
      identifier: referrer.identifier,
      type: referrer.type,
      screen: referrer.screen?.toPigeon()),
  AppMetricaECommerceCartItem: (AppMetricaECommerceCartItem cartItem) => ECommerceCartItemPigeon(
      product: cartItem.product.toPigeon(),
      quantity: cartItem.quantity.toString(),
      revenue: cartItem.revenue.toPigeon(),
      referrer: cartItem.referrer?.toPigeon()),
  AppMetricaECommerceOrder: (AppMetricaECommerceOrder order) => ECommerceOrderPigeon(
      identifier: order.identifier,
      items: order.items.map((e) => e.toPigeon()).toList(),
      payload: order.payload),
  AppMetricaECommerceAmount: (AppMetricaECommerceAmount amount) => ECommerceAmountPigeon(
      amount: amount.amount.toString(), currency: amount.currency),
  AppMetricaECommercePrice: (AppMetricaECommercePrice price) => ECommercePricePigeon(
      fiat: price.fiat.toPigeon(),
      internalComponents:
          price.internalComponents?.map((e) => e.toPigeon()).toList())
};
