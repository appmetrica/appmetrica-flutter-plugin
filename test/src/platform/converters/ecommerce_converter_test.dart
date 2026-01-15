import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/ecommerce_converter.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ECommerceAmountConverter', () {
    test('converts amount with integer value', () {
      final amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('100'),
        currency: 'USD',
      );

      final pigeon = amount.toPigeon();

      expect(pigeon.amount, '100');
      expect(pigeon.currency, 'USD');
    });

    test('converts amount with decimal value', () {
      final amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('99.99'),
        currency: 'EUR',
      );

      final pigeon = amount.toPigeon();

      expect(pigeon.amount, '99.99');
      expect(pigeon.currency, 'EUR');
    });

    test('converts amount with many decimal places', () {
      final amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('0.00000001'),
        currency: 'BTC',
      );

      final pigeon = amount.toPigeon();

      expect(pigeon.amount, '0.00000001');
    });

    test('converts zero amount', () {
      final amount = AppMetricaECommerceAmount(
        amount: Decimal.zero,
        currency: 'USD',
      );

      final pigeon = amount.toPigeon();

      expect(pigeon.amount, '0');
    });

    test('converts negative amount', () {
      final amount = AppMetricaECommerceAmount(
        amount: Decimal.parse('-50.00'),
        currency: 'USD',
      );

      final pigeon = amount.toPigeon();

      expect(pigeon.amount, '-50');
    });
  });

  group('ECommercePriceConverter', () {
    test('converts price with fiat only', () {
      final price = AppMetricaECommercePrice(
        fiat: AppMetricaECommerceAmount(
          amount: Decimal.parse('29.99'),
          currency: 'USD',
        ),
      );

      final pigeon = price.toPigeon();

      expect(pigeon.fiat.amount, '29.99');
      expect(pigeon.fiat.currency, 'USD');
      expect(pigeon.internalComponents, null);
    });

    test('converts price with internal components', () {
      final price = AppMetricaECommercePrice(
        fiat: AppMetricaECommerceAmount(
          amount: Decimal.parse('100'),
          currency: 'USD',
        ),
        internalComponents: [
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

      final pigeon = price.toPigeon();

      expect(pigeon.fiat.amount, '100');
      expect(pigeon.internalComponents?.length, 2);
      expect(pigeon.internalComponents?[0]?.amount, '500');
      expect(pigeon.internalComponents?[0]?.currency, 'COINS');
      expect(pigeon.internalComponents?[1]?.amount, '10');
      expect(pigeon.internalComponents?[1]?.currency, 'GEMS');
    });

    test('converts price with empty internal components', () {
      final price = AppMetricaECommercePrice(
        fiat: AppMetricaECommerceAmount(
          amount: Decimal.one,
          currency: 'USD',
        ),
        internalComponents: [],
      );

      final pigeon = price.toPigeon();

      expect(pigeon.internalComponents, isEmpty);
    });
  });

  group('ECommerceScreenConverter', () {
    test('converts screen with all fields', () {
      const screen = AppMetricaECommerceScreen(
        name: 'ProductList',
        categoriesPath: ['Electronics', 'Phones', 'Smartphones'],
        searchQuery: 'iphone 15',
        payload: {'source': 'search', 'filter': 'price_asc'},
      );

      final pigeon = screen.toPigeon();

      expect(pigeon.name, 'ProductList');
      expect(pigeon.categoriesPath, ['Electronics', 'Phones', 'Smartphones']);
      expect(pigeon.searchQuery, 'iphone 15');
      expect(pigeon.payload, {'source': 'search', 'filter': 'price_asc'});
    });

    test('converts screen with only name', () {
      const screen = AppMetricaECommerceScreen(name: 'HomePage');

      final pigeon = screen.toPigeon();

      expect(pigeon.name, 'HomePage');
      expect(pigeon.categoriesPath, null);
      expect(pigeon.searchQuery, null);
      expect(pigeon.payload, null);
    });

    test('converts screen with empty fields', () {
      const screen = AppMetricaECommerceScreen(
        name: '',
        categoriesPath: [],
        searchQuery: '',
        payload: {},
      );

      final pigeon = screen.toPigeon();

      expect(pigeon.name, '');
      expect(pigeon.categoriesPath, isEmpty);
      expect(pigeon.searchQuery, '');
      expect(pigeon.payload, isEmpty);
    });

    test('converts screen with unicode characters', () {
      const screen = AppMetricaECommerceScreen(
        name: 'Категория товаров',
        searchQuery: '手机',
        payload: {'emoji': '🛒'},
      );

      final pigeon = screen.toPigeon();

      expect(pigeon.name, 'Категория товаров');
      expect(pigeon.searchQuery, '手机');
      expect(pigeon.payload?['emoji'], '🛒');
    });
  });

  group('ECommerceProductConverter', () {
    test('converts product with all fields', () {
      final product = AppMetricaECommerceProduct(
        sku: 'SKU-12345',
        name: 'iPhone 15 Pro',
        categoriesPath: ['Electronics', 'Phones'],
        payload: {'brand': 'Apple', 'color': 'Black'},
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
        promocodes: ['SALE10', 'NEWYEAR'],
      );

      final pigeon = product.toPigeon();

      expect(pigeon.sku, 'SKU-12345');
      expect(pigeon.name, 'iPhone 15 Pro');
      expect(pigeon.categoriesPath, ['Electronics', 'Phones']);
      expect(pigeon.payload, {'brand': 'Apple', 'color': 'Black'});
      expect(pigeon.actualPrice?.fiat.amount, '999');
      expect(pigeon.originalPrice?.fiat.amount, '1099');
      expect(pigeon.promocodes, ['SALE10', 'NEWYEAR']);
    });

    test('converts product with only sku', () {
      const product = AppMetricaECommerceProduct(sku: 'MINIMAL-SKU');

      final pigeon = product.toPigeon();

      expect(pigeon.sku, 'MINIMAL-SKU');
      expect(pigeon.name, null);
      expect(pigeon.categoriesPath, null);
      expect(pigeon.payload, null);
      expect(pigeon.actualPrice, null);
      expect(pigeon.originalPrice, null);
      expect(pigeon.promocodes, null);
    });

    test('converts product with empty promocodes', () {
      const product = AppMetricaECommerceProduct(
        sku: 'SKU-001',
        promocodes: [],
      );

      final pigeon = product.toPigeon();

      expect(pigeon.promocodes, isEmpty);
    });
  });

  group('ECommerceReferrerConverter', () {
    test('converts referrer with all fields', () {
      const referrer = AppMetricaECommerceReferrer(
        type: 'button',
        identifier: 'add_to_cart_button',
        screen: AppMetricaECommerceScreen(name: 'ProductPage'),
      );

      final pigeon = referrer.toPigeon();

      expect(pigeon.type, 'button');
      expect(pigeon.identifier, 'add_to_cart_button');
      expect(pigeon.screen?.name, 'ProductPage');
    });

    test('converts referrer with no fields', () {
      const referrer = AppMetricaECommerceReferrer();

      final pigeon = referrer.toPigeon();

      expect(pigeon.type, null);
      expect(pigeon.identifier, null);
      expect(pigeon.screen, null);
    });

    test('converts referrer with only type', () {
      const referrer = AppMetricaECommerceReferrer(type: 'deeplink');

      final pigeon = referrer.toPigeon();

      expect(pigeon.type, 'deeplink');
      expect(pigeon.identifier, null);
    });
  });

  group('ECommerceCartItemConverter', () {
    test('converts cart item with all fields', () {
      final cartItem = AppMetricaECommerceCartItem(
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

      final pigeon = cartItem.toPigeon();

      expect(pigeon.product.sku, 'PROD-001');
      expect(pigeon.quantity, '2');
      expect(pigeon.revenue.fiat.amount, '49.98');
      expect(pigeon.referrer?.type, 'recommendation');
    });

    test('converts cart item without referrer', () {
      final cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'PROD-002'),
        quantity: Decimal.parse('1.5'),
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('15.00'),
            currency: 'EUR',
          ),
        ),
      );

      final pigeon = cartItem.toPigeon();

      expect(pigeon.product.sku, 'PROD-002');
      expect(pigeon.quantity, '1.5');
      expect(pigeon.referrer, null);
    });

    test('converts cart item with fractional quantity', () {
      final cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'WEIGHT-001'),
        quantity: Decimal.parse('0.750'),
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('7.50'),
            currency: 'USD',
          ),
        ),
      );

      final pigeon = cartItem.toPigeon();

      expect(pigeon.quantity, '0.75');
    });
  });

  group('ECommerceOrderConverter', () {
    test('converts order with all fields', () {
      final order = AppMetricaECommerceOrder(
        identifier: 'ORDER-2024-001',
        items: [
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
        payload: {'coupon': 'DISCOUNT20', 'shipping': 'express'},
      );

      final pigeon = order.toPigeon();

      expect(pigeon.identifier, 'ORDER-2024-001');
      expect(pigeon.items.length, 2);
      expect(pigeon.items[0]?.product.sku, 'SKU-1');
      expect(pigeon.items[1]?.product.sku, 'SKU-2');
      expect(pigeon.payload, {'coupon': 'DISCOUNT20', 'shipping': 'express'});
    });

    test('converts order without payload', () {
      final order = AppMetricaECommerceOrder(
        identifier: 'ORDER-002',
        items: [
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

      final pigeon = order.toPigeon();

      expect(pigeon.identifier, 'ORDER-002');
      expect(pigeon.items.length, 1);
      expect(pigeon.payload, null);
    });
  });

  group('ECommerceEventConverter', () {
    test('converts showScreenEvent', () {
      const screen = AppMetricaECommerceScreen(name: 'MainScreen');
      final event = AppMetricaECommerce.showScreenEvent(screen);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_screen_event');
      expect(pigeon.screen?.name, 'MainScreen');
      expect(pigeon.product, null);
      expect(pigeon.cartItem, null);
      expect(pigeon.order, null);
    });

    test('converts showProductCardEvent', () {
      const product = AppMetricaECommerceProduct(sku: 'SKU-CARD');
      const screen = AppMetricaECommerceScreen(name: 'SearchResults');
      final event = AppMetricaECommerce.showProductCardEvent(product, screen);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_product_card_event');
      expect(pigeon.product?.sku, 'SKU-CARD');
      expect(pigeon.screen?.name, 'SearchResults');
    });

    test('converts showProductDetailsEvent with referrer', () {
      const product = AppMetricaECommerceProduct(sku: 'SKU-DETAILS');
      const referrer = AppMetricaECommerceReferrer(type: 'push');
      final event =
          AppMetricaECommerce.showProductDetailsEvent(product, referrer);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_product_details_event');
      expect(pigeon.product?.sku, 'SKU-DETAILS');
      expect(pigeon.referrer?.type, 'push');
    });

    test('converts showProductDetailsEvent without referrer', () {
      const product = AppMetricaECommerceProduct(sku: 'SKU-NO-REF');
      final event = AppMetricaECommerce.showProductDetailsEvent(product, null);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'show_product_details_event');
      expect(pigeon.product?.sku, 'SKU-NO-REF');
      expect(pigeon.referrer, null);
    });

    test('converts addCartItemEvent', () {
      final cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'ADD-SKU'),
        quantity: Decimal.one,
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('10'),
            currency: 'USD',
          ),
        ),
      );
      final event = AppMetricaECommerce.addCartItemEvent(cartItem);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'add_cart_item_event');
      expect(pigeon.cartItem?.product.sku, 'ADD-SKU');
    });

    test('converts removeCartItemEvent', () {
      final cartItem = AppMetricaECommerceCartItem(
        product: const AppMetricaECommerceProduct(sku: 'REMOVE-SKU'),
        quantity: Decimal.one,
        revenue: AppMetricaECommercePrice(
          fiat: AppMetricaECommerceAmount(
            amount: Decimal.parse('10'),
            currency: 'USD',
          ),
        ),
      );
      final event = AppMetricaECommerce.removeCartItemEvent(cartItem);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'remove_cart_item_event');
      expect(pigeon.cartItem?.product.sku, 'REMOVE-SKU');
    });

    test('converts beginCheckoutEvent', () {
      final order = AppMetricaECommerceOrder(
        identifier: 'CHECKOUT-001',
        items: [
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
      final event = AppMetricaECommerce.beginCheckoutEvent(order);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'begin_checkout_event');
      expect(pigeon.order?.identifier, 'CHECKOUT-001');
    });

    test('converts purchaseEvent', () {
      final order = AppMetricaECommerceOrder(
        identifier: 'PURCHASE-001',
        items: [
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
        payload: {'payment_method': 'card'},
      );
      final event = AppMetricaECommerce.purchaseEvent(order);

      final pigeon = event.toPigeon();

      expect(pigeon.eventType, 'purchase_event');
      expect(pigeon.order?.identifier, 'PURCHASE-001');
      expect(pigeon.order?.payload, {'payment_method': 'card'});
    });
  });
}
