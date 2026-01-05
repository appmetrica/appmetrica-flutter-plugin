import '../../models/ecommerce.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

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
      eventType: event.eventType,
      cartItem: event.cartItem?.toPigeon(),
      order: event.order?.toPigeon(),
      product: event.product?.toPigeon(),
      referrer: event.referrer?.toPigeon(),
      screen: event.screen?.toPigeon()),
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
