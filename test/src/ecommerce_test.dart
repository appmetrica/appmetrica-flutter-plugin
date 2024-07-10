import 'package:appmetrica_plugin/src/ecommerce.dart';
import 'package:appmetrica_plugin/src/ecommerce_event.dart';
import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ecommerce_test.mocks.dart';

class EventConverter extends Mock {
  ECommerceEventPigeon call(AppMetricaECommerceEvent event);
}

class ScreenConverter extends Mock {
  ECommerceScreenPigeon call(AppMetricaECommerceScreen screen);
}

class ProductConverter extends Mock {
  ECommerceProductPigeon call(AppMetricaECommerceProduct product);
}

class ReferrerConverter extends Mock {
  ECommerceReferrerPigeon call(AppMetricaECommerceReferrer referrer);
}

class CartItemConverter extends Mock {
  ECommerceCartItemPigeon call(AppMetricaECommerceCartItem cartItem);
}

class OrderConverter extends Mock {
  ECommerceOrderPigeon call(AppMetricaECommerceOrder order);
}

class PriceConverter extends Mock {
  ECommercePricePigeon call(AppMetricaECommercePrice price);
}

class AmountConverter extends Mock {
  ECommerceAmountPigeon call(AppMetricaECommerceAmount amount);
}

@GenerateMocks(
  [
    EventConverter,
    ScreenConverter,
    ProductConverter,
    ReferrerConverter,
    CartItemConverter,
    OrderConverter,
    PriceConverter,
    AmountConverter
  ],
)
void main() {
  const screen = AppMetricaECommerceScreen();
  const product = AppMetricaECommerceProduct(sku: "sku");
  const referrer = AppMetricaECommerceReferrer();
  final amount = AppMetricaECommerceAmount(amount: Decimal.fromInt(100), currency: "USD");
  final price = AppMetricaECommercePrice(fiat: amount);
  final cartItem = AppMetricaECommerceCartItem(
      product: product, quantity: Decimal.fromInt(10), revenue: price);
  final order = AppMetricaECommerceOrder(identifier: "identifier", items: [cartItem]);
  final event = AppMetricaECommerce.showScreenEvent(screen);

  final eventConverter = MockEventConverter();
  final screenConverter = MockScreenConverter();
  final productConverter = MockProductConverter();
  final referrerConverter = MockReferrerConverter();
  final cartItemConverter = MockCartItemConverter();
  final orderConverter = MockOrderConverter();
  final priceConverter = MockPriceConverter();
  final amountConverter = MockAmountConverter();

  final eCommerceEventPigeon = ECommerceEventPigeon(eventType: "eventType");
  final eCommerceScreenPigeon = ECommerceScreenPigeon();
  final eCommerceProductPigeon = ECommerceProductPigeon(sku: "sku");
  final eCommerceReferrerPigeon = ECommerceReferrerPigeon();
  final eCommerceAmountPigeon =
      ECommerceAmountPigeon(amount: "100", currency: "USD");
  final eCommercePricePigeon =
      ECommercePricePigeon(fiat: eCommerceAmountPigeon);
  final eCommerceCartItemPigeon = ECommerceCartItemPigeon(
      product: eCommerceProductPigeon,
      quantity: "10",
      revenue: eCommercePricePigeon);
  final eCommerceOrderPigeon =
      ECommerceOrderPigeon(identifier: "id", items: [eCommerceCartItemPigeon]);

  Map<Type, Function> backUpConverters = {};

  setUp(() {
    backUpConverters = Map.from(eCommerceConverters);

    when(screenConverter.call(any)).thenReturn(eCommerceScreenPigeon);
    when(productConverter.call(any)).thenReturn(eCommerceProductPigeon);
    when(referrerConverter.call(any)).thenReturn(eCommerceReferrerPigeon);
    when(orderConverter.call(any)).thenReturn(eCommerceOrderPigeon);
    when(priceConverter.call(any)).thenReturn(eCommercePricePigeon);
    when(amountConverter.call(any)).thenReturn(eCommerceAmountPigeon);
  });

  tearDown(() {
    eCommerceConverters.addAll(backUpConverters);
  });

  test("ECommerce Screen Event", () {
    eCommerceConverters[AppMetricaECommerceScreen] = screenConverter;

    final pigeon = AppMetricaECommerce.showScreenEvent(screen).toPigeon();

    verify(screenConverter.call(screen));
    expect(pigeon.eventType, "show_screen_event");
    expect(pigeon.screen, eCommerceScreenPigeon);
  });

  test("ECommerce Product Card Event", () {
    eCommerceConverters[AppMetricaECommerceScreen] = screenConverter;
    eCommerceConverters[AppMetricaECommerceProduct] = productConverter;

    final pigeon = AppMetricaECommerce.showProductCardEvent(product, screen).toPigeon();

    verify(screenConverter.call(screen));
    verify(productConverter.call(product));
    expect(pigeon.eventType, "show_product_card_event");
    expect(pigeon.screen, eCommerceScreenPigeon);
    expect(pigeon.product, eCommerceProductPigeon);
  });

  test("ECommerce Product Details Event", () {
    eCommerceConverters[AppMetricaECommerceProduct] = productConverter;
    eCommerceConverters[AppMetricaECommerceReferrer] = referrerConverter;

    final pigeon =
        AppMetricaECommerce.showProductDetailsEvent(product, referrer).toPigeon();

    verify(productConverter.call(product));
    verify(referrerConverter.call(referrer));
    expect(pigeon.eventType, "show_product_details_event");
    expect(pigeon.product, eCommerceProductPigeon);
    expect(pigeon.referrer, eCommerceReferrerPigeon);
  });

  test("ECommerce Add Cart Item Event", () {
    eCommerceConverters[AppMetricaECommerceCartItem] = cartItemConverter;

    when(cartItemConverter.call(any)).thenReturn(eCommerceCartItemPigeon);

    final pigeon = AppMetricaECommerce.addCartItemEvent(cartItem).toPigeon();

    verify(cartItemConverter.call(cartItem));
    expect(pigeon.eventType, "add_cart_item_event");
    expect(pigeon.cartItem, eCommerceCartItemPigeon);
  });

  test("ECommerce Remove Cart Item Event", () {
    eCommerceConverters[AppMetricaECommerceCartItem] = cartItemConverter;

    when(cartItemConverter.call(any)).thenReturn(eCommerceCartItemPigeon);

    final pigeon = AppMetricaECommerce.removeCartItemEvent(cartItem).toPigeon();

    verify(cartItemConverter.call(cartItem));
    expect(pigeon.eventType, "remove_cart_item_event");
    expect(pigeon.cartItem, eCommerceCartItemPigeon);
  });

  test("ECommerce Begin Checkout Event", () {
    eCommerceConverters[AppMetricaECommerceOrder] = orderConverter;

    final pigeon = AppMetricaECommerce.beginCheckoutEvent(order).toPigeon();

    verify(orderConverter.call(order));
    expect(pigeon.eventType, "begin_checkout_event");
    expect(pigeon.order, eCommerceOrderPigeon);
  });

  test("ECommerce Purchase Event Event", () {
    eCommerceConverters[AppMetricaECommerceOrder] = orderConverter;

    final pigeon = AppMetricaECommerce.purchaseEvent(order).toPigeon();

    verify(orderConverter.call(order));
    expect(pigeon.eventType, "purchase_event");
    expect(pigeon.order, eCommerceOrderPigeon);
  });

  test("ECommerce Amount Conversion", () {
    eCommerceConverters[AppMetricaECommerceAmount] = amountConverter;

    final pigeon = price.toPigeon();

    verify(amountConverter.call(amount));
    expect(pigeon.fiat, eCommerceAmountPigeon);
  });

  test("ECommerce Price Conversion", () {
    eCommerceConverters[AppMetricaECommercePrice] = priceConverter;

    final pigeon = cartItem.toPigeon();

    verify(priceConverter.call(price));
    expect(pigeon.revenue, eCommercePricePigeon);
  });

  test("ECommerce Event Conversion", () {
    eCommerceConverters[AppMetricaECommerceEvent] = eventConverter;
    when(eventConverter.call(event)).thenReturn(eCommerceEventPigeon);

    final pigeon = event.toPigeon();

    verify(eventConverter.call(event));
    expect(pigeon, eCommerceEventPigeon);
  });
}
