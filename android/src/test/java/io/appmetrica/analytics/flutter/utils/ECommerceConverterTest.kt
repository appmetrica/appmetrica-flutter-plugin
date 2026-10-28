package io.appmetrica.analytics.flutter.utils

import org.assertj.core.api.Assertions.assertThat
import io.appmetrica.analytics.ecommerce.ECommerceAmount
import io.appmetrica.analytics.ecommerce.ECommerceCartItem
import io.appmetrica.analytics.ecommerce.ECommerceEvent
import io.appmetrica.analytics.ecommerce.ECommerceOrder
import io.appmetrica.analytics.ecommerce.ECommercePrice
import io.appmetrica.analytics.ecommerce.ECommerceProduct
import io.appmetrica.analytics.ecommerce.ECommerceReferrer
import io.appmetrica.analytics.ecommerce.ECommerceScreen
import io.appmetrica.analytics.flutter.pigeon.Pigeon
import org.junit.Test
import org.mockito.ArgumentMatchers.any
import org.mockito.Mockito
import org.mockito.invocation.InvocationOnMock
import java.math.BigDecimal

class ECommerceConverterTest {

    @Test
    fun `toNative converts all event types with nested product price referrer and order fields`() {
        val screenPigeon = Pigeon.ECommerceScreenPigeon.Builder()
            .setName("ProductList")
            .setCategoriesPath(listOf("Electronics", "Phones", "Smartphones"))
            .setSearchQuery("iphone 15")
            .setPayload(mapOf("source" to "search", "filter" to "price_asc"))
            .build()

        val pricePigeon = Pigeon.ECommercePricePigeon.Builder()
            .setFiat(Pigeon.ECommerceAmountPigeon.Builder().setAmount("999").setCurrency("USD").build())
            .setInternalComponents(
                listOf(
                    Pigeon.ECommerceAmountPigeon.Builder().setAmount("500").setCurrency("COINS").build(),
                    Pigeon.ECommerceAmountPigeon.Builder().setAmount("10").setCurrency("GEMS").build(),
                )
            )
            .build()

        val productPigeon = Pigeon.ECommerceProductPigeon.Builder()
            .setSku("SKU-12345")
            .setName("iPhone 15 Pro")
            .setCategoriesPath(listOf("Electronics", "Phones"))
            .setPayload(mapOf("brand" to "Apple", "color" to "Black"))
            .setActualPrice(pricePigeon)
            .setOriginalPrice(
                Pigeon.ECommercePricePigeon.Builder()
                    .setFiat(Pigeon.ECommerceAmountPigeon.Builder().setAmount("1099").setCurrency("USD").build())
                    .build()
            )
            .setPromocodes(listOf("SALE10", "NEWYEAR"))
            .build()

        val referrerPigeon = Pigeon.ECommerceReferrerPigeon.Builder()
            .setType("button")
            .setIdentifier("add_to_cart_button")
            .setScreen(Pigeon.ECommerceScreenPigeon.Builder().setName("ProductPage").build())
            .build()

        val cartItemPigeon = Pigeon.ECommerceCartItemPigeon.Builder()
            .setProduct(
                Pigeon.ECommerceProductPigeon.Builder().setSku("PROD-001").setName("Test Product").build()
            )
            .setQuantity("2")
            .setRevenue(
                Pigeon.ECommercePricePigeon.Builder()
                    .setFiat(Pigeon.ECommerceAmountPigeon.Builder().setAmount("49.98").setCurrency("USD").build())
                    .build()
            )
            .setReferrer(Pigeon.ECommerceReferrerPigeon.Builder().setType("recommendation").build())
            .build()

        val orderPigeon = Pigeon.ECommerceOrderPigeon.Builder()
            .setIdentifier("ORDER-2024-001")
            .setItems(
                listOf(
                    Pigeon.ECommerceCartItemPigeon.Builder()
                        .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("SKU-1").build())
                        .setQuantity("1")
                        .setRevenue(
                            Pigeon.ECommercePricePigeon.Builder()
                                .setFiat(
                                    Pigeon.ECommerceAmountPigeon.Builder().setAmount("100").setCurrency("USD").build()
                                )
                                .build()
                        )
                        .build(),
                    Pigeon.ECommerceCartItemPigeon.Builder()
                        .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("SKU-2").build())
                        .setQuantity("2")
                        .setRevenue(
                            Pigeon.ECommercePricePigeon.Builder()
                                .setFiat(
                                    Pigeon.ECommerceAmountPigeon.Builder().setAmount("50").setCurrency("USD").build()
                                )
                                .build()
                        )
                        .build(),
                )
            )
            .setPayload(mapOf("coupon" to "DISCOUNT20", "shipping" to "express"))
            .build()

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var capturedScreen: ECommerceScreen? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showScreenEvent(any(ECommerceScreen::class.java))
            }.thenAnswer { inv: InvocationOnMock ->
                capturedScreen = inv.getArgument(0)
                stub
            }
            capturedScreen = null

            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_screen_event")
                        .setScreen(screenPigeon)
                        .build()
                )
            ).isSameAs(stub)
            assertThat(capturedScreen).isNotNull
            assertThat(capturedScreen!!.name).isEqualTo("ProductList")
            assertThat(capturedScreen!!.categoriesPath)
                .containsExactly("Electronics", "Phones", "Smartphones")
            assertThat(capturedScreen!!.searchQuery).isEqualTo("iphone 15")
            assertThat(capturedScreen!!.payload)
                .isEqualTo(mapOf("source" to "search", "filter" to "price_asc"))
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var capturedProduct: ECommerceProduct? = null
            var capturedScreen: ECommerceScreen? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showProductCardEvent(
                    any(ECommerceProduct::class.java),
                    any(ECommerceScreen::class.java),
                )
            }.thenAnswer { inv ->
                capturedProduct = inv.getArgument(0)
                capturedScreen = inv.getArgument(1)
                stub
            }

            capturedScreen = null
            capturedProduct = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_product_card_event")
                        .setProduct(productPigeon)
                        .setScreen(screenPigeon)
                        .build()
                )
            ).isSameAs(stub)
            checkScreen(
                capturedScreen!!,
                name = "ProductList",
                categoriesPath = listOf("Electronics", "Phones", "Smartphones"),
                searchQuery = "iphone 15",
                payload = mapOf("source" to "search", "filter" to "price_asc"),
            )
            checkProduct(
                capturedProduct!!,
                sku = "SKU-12345",
                name = "iPhone 15 Pro",
                categoriesPath = listOf("Electronics", "Phones"),
                payload = mapOf("brand" to "Apple", "color" to "Black"),
                promocodes = listOf("SALE10", "NEWYEAR"),
            )
            checkPrice(capturedProduct!!.actualPrice!!, "999", "USD", listOf("500" to "COINS", "10" to "GEMS"))
            checkPrice(capturedProduct!!.originalPrice!!, "1099", "USD", null)
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var capturedProduct: ECommerceProduct? = null
            var capturedReferrer: ECommerceReferrer? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showProductDetailsEvent(
                    any(ECommerceProduct::class.java),
                    any(ECommerceReferrer::class.java),
                )
            }.thenAnswer { inv ->
                capturedProduct = inv.getArgument(0)
                capturedReferrer = inv.getArgument(1)
                stub
            }

            capturedProduct = null
            capturedReferrer = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_product_details_event")
                        .setProduct(productPigeon)
                        .setReferrer(referrerPigeon)
                        .build()
                )
            ).isSameAs(stub)
            checkProduct(capturedProduct!!, sku = "SKU-12345", name = "iPhone 15 Pro")
            checkReferrer(
                capturedReferrer!!,
                type = "button",
                identifier = "add_to_cart_button",
                screenName = "ProductPage",
            )
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var capturedProduct: ECommerceProduct? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showProductDetailsEvent(any(ECommerceProduct::class.java), Mockito.isNull())
            }.thenAnswer { inv ->
                capturedProduct = inv.getArgument(0)
                stub
            }

            capturedProduct = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_product_details_event")
                        .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("SKU-NO-REF").build())
                        .build()
                )
            ).isSameAs(stub)
            checkProduct(capturedProduct!!, sku = "SKU-NO-REF", checkOptionalNulls = true)
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var captured: ECommerceCartItem? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.addCartItemEvent(any(ECommerceCartItem::class.java))
            }.thenAnswer { inv ->
                captured = inv.getArgument(0)
                stub
            }

            captured = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("add_cart_item_event")
                        .setCartItem(cartItemPigeon)
                        .build()
                )
            ).isSameAs(stub)
            checkCartItem(
                captured!!,
                sku = "PROD-001",
                productName = "Test Product",
                quantity = "2",
                revenueAmount = "49.98",
                revenueCurrency = "USD",
                referrerType = "recommendation",
            )
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var captured: ECommerceCartItem? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.removeCartItemEvent(any(ECommerceCartItem::class.java))
            }.thenAnswer { inv ->
                captured = inv.getArgument(0)
                stub
            }

            captured = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("remove_cart_item_event")
                        .setCartItem(
                            Pigeon.ECommerceCartItemPigeon.Builder()
                                .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("REMOVE-SKU").build())
                                .setQuantity("1")
                                .setRevenue(
                                    Pigeon.ECommercePricePigeon.Builder()
                                        .setFiat(
                                            Pigeon.ECommerceAmountPigeon.Builder()
                                                .setAmount("10")
                                                .setCurrency("USD")
                                                .build()
                                        )
                                        .build()
                                )
                                .build()
                        )
                        .build()
                )
            ).isSameAs(stub)
            checkCartItem(
                captured!!,
                sku = "REMOVE-SKU",
                quantity = "1",
                revenueAmount = "10",
                revenueCurrency = "USD",
            )
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var captured: ECommerceOrder? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.beginCheckoutEvent(any(ECommerceOrder::class.java))
            }.thenAnswer { inv ->
                captured = inv.getArgument(0)
                stub
            }

            captured = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("begin_checkout_event")
                        .setOrder(orderPigeon)
                        .build()
                )
            ).isSameAs(stub)
            checkOrder(
                captured!!,
                identifier = "ORDER-2024-001",
                payload = mapOf("coupon" to "DISCOUNT20", "shipping" to "express"),
                itemSkus = listOf("SKU-1", "SKU-2"),
                quantities = listOf("1", "2"),
                revenues = listOf("100" to "USD", "50" to "USD"),
            )
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var captured: ECommerceOrder? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.purchaseEvent(any(ECommerceOrder::class.java))
            }.thenAnswer { inv ->
                captured = inv.getArgument(0)
                stub
            }

            captured = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("purchase_event")
                        .setOrder(
                            Pigeon.ECommerceOrderPigeon.Builder()
                                .setIdentifier("PURCHASE-001")
                                .setItems(
                                    listOf(
                                        Pigeon.ECommerceCartItemPigeon.Builder()
                                            .setProduct(
                                                Pigeon.ECommerceProductPigeon.Builder()
                                                    .setSku("PURCHASE-ITEM")
                                                    .build()
                                            )
                                            .setQuantity("3")
                                            .setRevenue(
                                                Pigeon.ECommercePricePigeon.Builder()
                                                    .setFiat(
                                                        Pigeon.ECommerceAmountPigeon.Builder()
                                                            .setAmount("150")
                                                            .setCurrency("EUR")
                                                            .build()
                                                    )
                                                    .build()
                                            )
                                            .build()
                                    )
                                )
                                .setPayload(mapOf("payment_method" to "card"))
                                .build()
                        )
                        .build()
                )
            ).isSameAs(stub)
            checkOrder(
                captured!!,
                identifier = "PURCHASE-001",
                payload = mapOf("payment_method" to "card"),
                itemSkus = listOf("PURCHASE-ITEM"),
                quantities = listOf("3"),
                revenues = listOf("150" to "EUR"),
            )
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var captured: ECommerceCartItem? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.addCartItemEvent(any(ECommerceCartItem::class.java))
            }.thenAnswer { inv ->
                captured = inv.getArgument(0)
                stub
            }

            captured = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("add_cart_item_event")
                        .setCartItem(
                            Pigeon.ECommerceCartItemPigeon.Builder()
                                .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("WEIGHT-001").build())
                                .setQuantity("0.75")
                                .setRevenue(
                                    Pigeon.ECommercePricePigeon.Builder()
                                        .setFiat(
                                            Pigeon.ECommerceAmountPigeon.Builder()
                                                .setAmount("7.50")
                                                .setCurrency("USD")
                                                .build()
                                        )
                                        .build()
                                )
                                .build()
                        )
                        .build()
                )
            ).isSameAs(stub)
            checkCartItem(
                captured!!,
                sku = "WEIGHT-001",
                quantity = "0.75",
                revenueAmount = "7.50",
                revenueCurrency = "USD",
            )
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showScreenEvent(any(ECommerceScreen::class.java))
            }.thenReturn(stub)
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_screen_event")
                        .setScreen(Pigeon.ECommerceScreenPigeon.Builder().setName("HomePage").build())
                        .build()
                )
            ).isSameAs(stub)
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var capturedProduct: ECommerceProduct? = null
            var capturedScreen: ECommerceScreen? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showProductCardEvent(
                    any(ECommerceProduct::class.java),
                    any(ECommerceScreen::class.java),
                )
            }.thenAnswer { inv ->
                capturedProduct = inv.getArgument(0)
                capturedScreen = inv.getArgument(1)
                stub
            }

            capturedScreen = null
            capturedProduct = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_product_card_event")
                        .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("MINIMAL-SKU").build())
                        .setScreen(Pigeon.ECommerceScreenPigeon.Builder().setName("SearchResults").build())
                        .build()
                )
            ).isSameAs(stub)
            checkProduct(capturedProduct!!, sku = "MINIMAL-SKU", checkOptionalNulls = true)
            checkScreen(capturedScreen!!, name = "SearchResults")
        }

        Mockito.mockStatic(ECommerceEvent::class.java).use { mocked ->
            val stub = Mockito.mock(ECommerceEvent::class.java)
            var capturedReferrer: ECommerceReferrer? = null
            mocked.`when`<ECommerceEvent> {
                ECommerceEvent.showProductDetailsEvent(
                    any(ECommerceProduct::class.java),
                    any(ECommerceReferrer::class.java),
                )
            }.thenAnswer { inv ->
                capturedReferrer = inv.getArgument(1)
                stub
            }

            capturedReferrer = null
            assertThat(
                ECommerceConverter.toNative(
                    Pigeon.ECommerceEventPigeon.Builder()
                        .setEventType("show_product_details_event")
                        .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("SKU-EMPTY-REF").build())
                        .setReferrer(Pigeon.ECommerceReferrerPigeon.Builder().build())
                        .build()
                )
            ).isSameAs(stub)
            checkReferrer(capturedReferrer!!)
        }

        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder().setEventType("unknown_event_type").build()
            )
        ).isNull()
    }

    @Test
    fun `toNative returns null when required nested pigeons are missing`() {
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder().setEventType("show_screen_event").build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder()
                    .setEventType("show_product_card_event")
                    .setProduct(Pigeon.ECommerceProductPigeon.Builder().setSku("SKU-CARD").build())
                    .build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder()
                    .setEventType("show_product_card_event")
                    .setScreen(Pigeon.ECommerceScreenPigeon.Builder().setName("SearchResults").build())
                    .build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder()
                    .setEventType("show_product_details_event")
                    .setReferrer(Pigeon.ECommerceReferrerPigeon.Builder().setType("push").build())
                    .build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder().setEventType("add_cart_item_event").build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder().setEventType("remove_cart_item_event").build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder().setEventType("begin_checkout_event").build()
            )
        ).isNull()
        assertThat(
            ECommerceConverter.toNative(
                Pigeon.ECommerceEventPigeon.Builder().setEventType("purchase_event").build()
            )
        ).isNull()
    }

    private fun checkScreen(
        screen: ECommerceScreen,
        name: String? = null,
        categoriesPath: List<String>? = null,
        searchQuery: String? = null,
        payload: Map<String, String>? = null,
    ) {
        assertThat(screen.name).isEqualTo(name)
        if (categoriesPath == null) {
            assertThat(screen.categoriesPath).isNull()
        } else {
            assertThat(screen.categoriesPath).containsExactlyElementsOf(categoriesPath)
        }
        assertThat(screen.searchQuery).isEqualTo(searchQuery)
        assertThat(screen.payload).isEqualTo(payload)
    }

    private fun checkProduct(
        product: ECommerceProduct,
        sku: String,
        name: String? = null,
        categoriesPath: List<String>? = null,
        payload: Map<String, String>? = null,
        promocodes: List<String>? = null,
        checkOptionalNulls: Boolean = false,
    ) {
        assertThat(product.sku).isEqualTo(sku)
        assertThat(product.name).isEqualTo(name)
        if (categoriesPath != null) {
            assertThat(product.categoriesPath).containsExactlyElementsOf(categoriesPath)
        } else if (checkOptionalNulls) {
            assertThat(product.categoriesPath).isNull()
        }
        if (payload != null || checkOptionalNulls) {
            assertThat(product.payload).isEqualTo(payload)
        }
        if (promocodes != null) {
            assertThat(product.promocodes).containsExactlyElementsOf(promocodes)
        } else if (checkOptionalNulls) {
            assertThat(product.promocodes).isNull()
        }
    }

    private fun checkPrice(
        price: ECommercePrice,
        fiatAmount: String,
        fiatCurrency: String,
        internal: List<Pair<String, String>>?,
    ) {
        checkAmount(price.fiat, fiatAmount, fiatCurrency)
        if (internal == null) {
            assertThat(price.internalComponents).isNull()
        } else {
            assertThat(price.internalComponents).hasSize(internal.size)
            internal.forEachIndexed { index, (amount, currency) ->
                checkAmount(price.internalComponents!![index], amount, currency)
            }
        }
    }

    private fun checkAmount(amount: ECommerceAmount, value: String, currency: String) {
        assertThat(amount.amount).isEqualByComparingTo(BigDecimal(value))
        assertThat(amount.unit).isEqualTo(currency)
    }

    private fun checkReferrer(
        referrer: ECommerceReferrer,
        type: String? = null,
        identifier: String? = null,
        screenName: String? = null,
    ) {
        assertThat(referrer.type).isEqualTo(type)
        assertThat(referrer.identifier).isEqualTo(identifier)
        if (screenName == null) {
            assertThat(referrer.screen).isNull()
        } else {
            checkScreen(referrer.screen!!, name = screenName)
        }
    }

    private fun checkCartItem(
        item: ECommerceCartItem,
        sku: String,
        productName: String? = null,
        quantity: String,
        revenueAmount: String,
        revenueCurrency: String,
        referrerType: String? = null,
    ) {
        checkProduct(item.product, sku = sku, name = productName, checkOptionalNulls = productName == null)
        assertThat(item.quantity).isEqualByComparingTo(BigDecimal(quantity))
        checkPrice(item.revenue, revenueAmount, revenueCurrency, null)
        if (referrerType == null) {
            assertThat(item.referrer).isNull()
        } else {
            checkReferrer(item.referrer!!, type = referrerType)
        }
    }

    private fun checkOrder(
        order: ECommerceOrder,
        identifier: String,
        payload: Map<String, String>,
        itemSkus: List<String>,
        quantities: List<String>,
        revenues: List<Pair<String, String>>,
    ) {
        assertThat(order.identifier).isEqualTo(identifier)
        assertThat(order.payload).isEqualTo(payload)
        assertThat(order.cartItems).hasSize(itemSkus.size)
        itemSkus.forEachIndexed { index, sku ->
            checkCartItem(
                order.cartItems[index],
                sku = sku,
                quantity = quantities[index],
                revenueAmount = revenues[index].first,
                revenueCurrency = revenues[index].second,
            )
        }
    }
}
