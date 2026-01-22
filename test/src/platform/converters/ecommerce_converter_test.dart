import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/ecommerce_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ECommerceAmountConverter', () {
    test('converts amount with integer value', () {
      final AppMetricaECommerceAmount amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('100'),
        currency: 'USD',
      );

      final ECommerceAmountPigeon pigeon = amount.toPigeon();

      expect(pigeon.amount, '100');
      expect(pigeon.currency, 'USD');
    });

    test('converts amount with decimal value', () {
      final AppMetricaECommerceAmount amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('99.99'),
        currency: 'EUR',
      );

      final ECommerceAmountPigeon pigeon = amount.toPigeon();

      expect(pigeon.amount, '99.99');
      expect(pigeon.currency, 'EUR');
    });

    test('converts amount with many decimal places', () {
      final AppMetricaECommerceAmount amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('0.00000001'),
        currency: 'BTC',
      );

      final ECommerceAmountPigeon pigeon = amount.toPigeon();

      expect(pigeon.amount, '0.00000001');
    });

    test('converts zero amount', () {
      final AppMetricaECommerceAmount amount = AppMetricaECommerceAmount(
        amount: Decimal.zero,
        currency: 'USD',
      );

      final ECommerceAmountPigeon pigeon = amount.toPigeon();

      expect(pigeon.amount, '0');
    });

    test('converts negative amount', () {
      final AppMetricaECommerceAmount amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('-50.00'),
        currency: 'USD',
      );

      final ECommerceAmountPigeon pigeon = amount.toPigeon();

      expect(pigeon.amount, '-50');
    });
  });

  group('ECommercePriceConverter', () {
    test('converts price with fiat only', () {
      final AppMetricaECommercePrice price = AppMetricaECommercePrice(
        fiat: AppMetricaECommerceAmount(
          amount: Decimal.parse('29.99'),
          currency: 'USD',
        ),
      );

      final ECommercePricePigeon pigeon = price.toPigeon();

      expect(pigeon.fiat.amount, '29.99');
      expect(pigeon.fiat.currency, 'USD');
      expect(pigeon.internalComponents, null);
    });

    test('converts price with internal components', () {
      final AppMetricaECommercePrice price = AppMetricaECommercePrice(
        fiat: AppMetricaECommerceAmount(
          amount: Decimal.parse('100'),
          currency: 'USD',
        ),
        internalComponents: <AppMetricaECommerceAmount>[
          AppMetricaECommerceAmount(
            amount: Decimal.parse('500'),
            currency: 'COINS',
          ),
          AppMetricaECommerceAmount(
            amount: Decimal.parse('10'),
            currency: 'GEMS',
          ),
        ],
      );

      final ECommercePricePigeon pigeon = price.toPigeon();

      expect(pigeon.fiat.amount, '100');
      expect(pigeon.internalComponents?.length, 2);
      expect(pigeon.internalComponents?[0]?.amount, '500');
      expect(pigeon.internalComponents?[0]?.currency, 'COINS');
      expect(pigeon.internalComponents?[1]?.amount, '10');
      expect(pigeon.internalComponents?[1]?.currency, 'GEMS');
    });

    test('converts price with empty internal components', () {
      final AppMetricaECommercePrice price = AppMetricaECommercePrice(
        fiat: AppMetricaECommerceAmount(
          amount: Decimal.one,
          currency: 'USD',
        ),
        internalComponents: <AppMetricaECommerceAmount>[],
      );

      final ECommercePricePigeon pigeon = price.toPigeon();

      expect(pigeon.internalComponents, isEmpty);
    });
  });

  group('ECommerceScreenConverter', () {
    test('converts screen with all fields', () {
      const AppMetricaECommerceScreen screen = AppMetricaECommerceScreen(
        name: 'ProductList',
        categoriesPath: <String>['Electronics', 'Phones', 'Smartphones'],
        searchQuery: 'iphone 15',
        payload: <String, String>{'source': 'search', 'filter': 'price_asc'},
      );

      final ECommerceScreenPigeon pigeon = screen.toPigeon();

      expect(pigeon.name, 'ProductList');
      expect(pigeon.categoriesPath, <String>['Electronics', 'Phones', 'Smartphones']);
      expect(pigeon.searchQuery, 'iphone 15');
      expect(pigeon.payload, <String, String>{'source': 'search', 'filter': 'price_asc'});
    });

    test('converts screen with only name', () {
      const AppMetricaECommerceScreen screen = AppMetricaECommerceScreen(name: 'HomePage');

      final ECommerceScreenPigeon pigeon = screen.toPigeon();

      expect(pigeon.name, 'HomePage');
      expect(pigeon.categoriesPath, null);
      expect(pigeon.searchQuery, null);
      expect(pigeon.payload, null);
    });

    test('converts screen with empty fields', () {
      const AppMetricaECommerceScreen screen = AppMetricaECommerceScreen(
        name: '',
        categoriesPath: <String>[],
        searchQuery: '',
        payload: <String, String>{},
      );

      final ECommerceScreenPigeon pigeon = screen.toPigeon();

      expect(pigeon.name, '');
      expect(pigeon.categoriesPath, isEmpty);
      expect(pigeon.searchQuery, '');
      expect(pigeon.payload, isEmpty);
    });

    test('converts screen with unicode characters', () {
      const AppMetricaECommerceScreen screen = AppMetricaECommerceScreen(
        name: 'Категория товаров',
        searchQuery: '手机',
        payload: <String, String>{'emoji': '🛒'},
      );

      final ECommerceScreenPigeon pigeon = screen.toPigeon();

      expect(pigeon.name, 'Категория товаров');
      expect(pigeon.searchQuery, '手机');
      expect(pigeon.payload?['emoji'], '🛒');
    });
  });

  group('ECommerceProductConverter', () {
    test('converts product with all fields', () {
      final AppMetricaECommerceProduct product = AppMetricaECommerceProduct(
        sku: 'SKU-12345',
        name: 'iPhone 15 Pro',
        categoriesPath: <String>['Electronics', 'Phones'],
        payload: <String, String>{'brand': 'Apple', 'color': 'Black'},
        actualPrice: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('999.00'),
            currency: 'USD',
          ),
        ),
        originalPrice: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('1099.00'),
            currency: 'USD',
          ),
        ),
        promocodes: <String>['SALE10', 'NEWYEAR'],
      );

      final ECommerceProductPigeon pigeon = product.toPigeon();

      expect(pigeon.sku, 'SKU-12345');
      expect(pigeon.name, 'iPhone 15 Pro');
      expect(pigeon.categoriesPath, <String>['Electronics', 'Phones']);
      expect(pigeon.payload, <String, String>{'brand': 'Apple', 'color': 'Black'});
      expect(pigeon.actualPrice?.fiat.amount, '999');
      expect(pigeon.originalPrice?.fiat.amount, '1099');
      expect(pigeon.promocodes, <String>['SALE10', 'NEWYEAR']);
    });

    test('converts product with only sku', () {
      const AppMetricaECommerceProduct product = AppMetricaECommerceProduct(sku: 'MINIMAL-SKU');

      final ECommerceProductPigeon pigeon = product.toPigeon();

      expect(pigeon.sku, 'MINIMAL-SKU');
      expect(pigeon.name, null);
      expect(pigeon.categoriesPath, null);
      expect(pigeon.payload, null);
      expect(pigeon.actualPrice, null);
      expect(pigeon.originalPrice, null);
      expect(pigeon.promocodes, null);
    });

    test('converts product with empty promocodes', () {
      const AppMetricaECommerceProduct product = AppMetricaECommerceProduct(
        sku: 'SKU-001',
        promocodes: <String>[],
      );

      final ECommerceProductPigeon pigeon = product.toPigeon();

      expect(pigeon.promocodes, isEmpty);
    });
  });

  group('ECommerceReferrerConverter', () {
    test('converts referrer with all fields', () {
      const AppMetricaECommerceReferrer referrer = AppMetricaECommerceReferrer(
        type: 'button',
        identifier: 'add_to_cart_button',
        screen: AppMetricaECommerceScreen(name: 'ProductPage'),
      );

      final ECommerceReferrerPigeon pigeon = referrer.toPigeon();

      expect(pigeon.type, 'button');
      expect(pigeon.identifier, 'add_to_cart_button');
      expect(pigeon.screen?.name, 'ProductPage');
    });

    test('converts referrer with no fields', () {
      const AppMetricaECommerceReferrer referrer = AppMetricaECommerceReferrer();

      final ECommerceReferrerPigeon pigeon = referrer.toPigeon();

      expect(pigeon.type, null);
      expect(pigeon.identifier, null);
      expect(pigeon.screen, null);
    });

    test('converts referrer with only type', () {
      const AppMetricaECommerceReferrer referrer = AppMetricaECommerceReferrer(type: 'deeplink');

      final ECommerceReferrerPigeon pigeon = referrer.toPigeon();

      expect(pigeon.type, 'deeplink');
      expect(pigeon.identifier, null);
    });
  });

  group('ECommerceCartItemConverter', () {
    test('converts cart item with all fields', () {
      final AppMetricaECommerceCartItem cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'PROD-001', name: 'Test Product'),
        quantity: Decimal.parse('2'),
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('49.98'),
            currency: 'USD',
          ),
        ),
        referrer: const AppMetricaECommerceReferrer(type: 'recommendation'),
      );

      final ECommerceCartItemPigeon pigeon = cartItem.toPigeon();

      expect(pigeon.product.sku, 'PROD-001');
      expect(pigeon.quantity, '2');
      expect(pigeon.revenue.fiat.amount, '49.98');
      expect(pigeon.referrer?.type, 'recommendation');
    });

    test('converts cart item without referrer', () {
      final AppMetricaECommerceCartItem cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'PROD-002'),
        quantity: Decimal.parse('1.5'),
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('15.00'),
            currency: 'EUR',
          ),
        ),
      );

      final ECommerceCartItemPigeon pigeon = cartItem.toPigeon();

      expect(pigeon.product.sku, 'PROD-002');
      expect(pigeon.quantity, '1.5');
      expect(pigeon.referrer, null);
    });

    test('converts cart item with fractional quantity', () {
      final AppMetricaECommerceCartItem cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'WEIGHT-001'),
        quantity: Decimal.parse('0.750'),
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('7.50'),
            currency: 'USD',
          ),
        ),
      );

      final ECommerceCartItemPigeon pigeon = cartItem.toPigeon();

      expect(pigeon.quantity, '0.75');
    });
  });

  group('ECommerceOrderConverter', () {
    test('converts order with all fields', () {
      final AppMetricaECommerceOrder order = AppMetricaECommerceOrder(
        identifier: 'ORDER-2024-001',
        items: <AppMetricaECommerceCartItem>[
          AppMetricaECommerceCartItem(
            product: const AppMetricaECommerceProduct(sku: 'SKU-1'),
            quantity: Decimal.one,
            revenue: AppMetricaECommercePrice(
              fiat: AppMetricaECommerceAmount(
                amount: Decimal.parse('100'),
                currency: 'USD',
              ),
            ),
          ),
          AppMetricaECommerceCartItem(
            product: const AppMetricaECommerceProduct(sku: 'SKU-2'),
            quantity: Decimal.parse('2'),
            revenue: AppMetricaECommercePrice(
              fiat: AppMetricaECommerceAmount(
                amount: Decimal.parse('50'),
                currency: 'USD',
              ),
            ),
          ),
        ],
        payload: <String, String>{'coupon': 'DISCOUNT20', 'shipping': 'express'},
      );

      final ECommerceOrderPigeon pigeon = order.toPigeon();

      expect(pigeon.identifier, 'ORDER-2024-001');
      expect(pigeon.items.length, 2);
      expect(pigeon.items[0]?.product.sku, 'SKU-1');
      expect(pigeon.items[1]?.product.sku, 'SKU-2');
      expect(pigeon.payload, <String, String>{'coupon': 'DISCOUNT20', 'shipping': 'express'});
    });

    test('converts order without payload', () {
      final AppMetricaECommerceOrder order = AppMetricaECommerceOrder(
        identifier: 'ORDER-002',
        items: <AppMetricaECommerceCartItem>[
          AppMetricaECommerceCartItem(
            product: const AppMetricaECommerceProduct(sku: 'ITEM-1'),
            quantity: Decimal.one,
            revenue: AppMetricaECommercePrice(
              fiat: AppMetricaECommerceAmount(
                amount: Decimal.parse('25'),
                currency: 'USD',
              ),
            ),
          ),
        ],
      );

      final ECommerceOrderPigeon pigeon = order.toPigeon();

      expect(pigeon.identifier, 'ORDER-002');
      expect(pigeon.items.length, 1);
      expect(pigeon.payload, null);
    });
  });

  group('ECommerceEventConverter', () {
    test('converts showScreenEvent', () {
      const AppMetricaECommerceScreen screen = AppMetricaECommerceScreen(name: 'MainScreen');
      final AppMetricaECommerceEvent event = AppMetricaECommerce.showScreenEvent(screen);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_screen_event');
      expect(pigeon.screen?.name, 'MainScreen');
      expect(pigeon.product, null);
      expect(pigeon.cartItem, null);
      expect(pigeon.order, null);
    });

    test('converts showProductCardEvent', () {
      const AppMetricaECommerceProduct product = AppMetricaECommerceProduct(sku: 'SKU-CARD');
      const AppMetricaECommerceScreen screen = AppMetricaECommerceScreen(name: 'SearchResults');
      final AppMetricaECommerceEvent event = AppMetricaECommerce.showProductCardEvent(product, screen);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_product_card_event');
      expect(pigeon.product?.sku, 'SKU-CARD');
      expect(pigeon.screen?.name, 'SearchResults');
    });

    test('converts showProductDetailsEvent with referrer', () {
      const AppMetricaECommerceProduct product = AppMetricaECommerceProduct(sku: 'SKU-DETAILS');
      const AppMetricaECommerceReferrer referrer = AppMetricaECommerceReferrer(type: 'push');
      final AppMetricaECommerceEvent event =
          AppMetricaECommerce.showProductDetailsEvent(product, referrer);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_product_details_event');
      expect(pigeon.product?.sku, 'SKU-DETAILS');
      expect(pigeon.referrer?.type, 'push');
    });

    test('converts showProductDetailsEvent without referrer', () {
      const AppMetricaECommerceProduct product = AppMetricaECommerceProduct(sku: 'SKU-NO-REF');
      final AppMetricaECommerceEvent event = AppMetricaECommerce.showProductDetailsEvent(product, null);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_product_details_event');
      expect(pigeon.product?.sku, 'SKU-NO-REF');
      expect(pigeon.referrer, null);
    });

    test('converts addCartItemEvent', () {
      final AppMetricaECommerceCartItem cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'ADD-SKU'),
        quantity: Decimal.one,
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('10'),
            currency: 'USD',
          ),
        ),
      );
      final AppMetricaECommerceEvent event = AppMetricaECommerce.addCartItemEvent(cartItem);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'add_cart_item_event');
      expect(pigeon.cartItem?.product.sku, 'ADD-SKU');
    });

    test('converts removeCartItemEvent', () {
      final AppMetricaECommerceCartItem cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'REMOVE-SKU'),
        quantity: Decimal.one,
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('10'),
            currency: 'USD',
          ),
        ),
      );
      final AppMetricaECommerceEvent event = AppMetricaECommerce.removeCartItemEvent(cartItem);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'remove_cart_item_event');
      expect(pigeon.cartItem?.product.sku, 'REMOVE-SKU');
    });

    test('converts beginCheckoutEvent', () {
      final AppMetricaECommerceOrder order = AppMetricaECommerceOrder(
        identifier: 'CHECKOUT-001',
        items: <AppMetricaECommerceCartItem>[
          AppMetricaECommerceCartItem(
            product: const AppMetricaECommerceProduct(sku: 'CHECKOUT-ITEM'),
            quantity: Decimal.one,
            revenue: AppMetricaECommercePrice(
              fiat: AppMetricaECommerceAmount(
                amount: Decimal.parse('100'),
                currency: 'USD',
              ),
            ),
          ),
        ],
      );
      final AppMetricaECommerceEvent event = AppMetricaECommerce.beginCheckoutEvent(order);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'begin_checkout_event');
      expect(pigeon.order?.identifier, 'CHECKOUT-001');
    });

    test('converts purchaseEvent', () {
      final AppMetricaECommerceOrder order = AppMetricaECommerceOrder(
        identifier: 'PURCHASE-001',
        items: <AppMetricaECommerceCartItem>[
          AppMetricaECommerceCartItem(
            product: const AppMetricaECommerceProduct(sku: 'PURCHASE-ITEM'),
            quantity: Decimal.parse('3'),
            revenue: AppMetricaECommercePrice(
              fiat: AppMetricaECommerceAmount(
                amount: Decimal.parse('150'),
                currency: 'EUR',
              ),
            ),
          ),
        ],
        payload: <String, String>{'payment_method': 'card'},
      );
      final AppMetricaECommerceEvent event = AppMetricaECommerce.purchaseEvent(order);

      final ECommerceEventPigeon pigeon = event.toPigeon();

      expect(pigeon.eventType, 'purchase_event');
      expect(pigeon.order?.identifier, 'PURCHASE-001');
      expect(pigeon.order?.payload, <String, String>{'payment_method': 'card'});
    });
  });
}
