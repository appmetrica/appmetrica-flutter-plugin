package io.appmetrica.analytics.flutter.utils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.ecommerce.ECommerceAmount;
import io.appmetrica.analytics.ecommerce.ECommerceCartItem;
import io.appmetrica.analytics.ecommerce.ECommerceEvent;
import io.appmetrica.analytics.ecommerce.ECommerceOrder;
import io.appmetrica.analytics.ecommerce.ECommercePrice;
import io.appmetrica.analytics.ecommerce.ECommerceProduct;
import io.appmetrica.analytics.ecommerce.ECommerceReferrer;
import io.appmetrica.analytics.ecommerce.ECommerceScreen;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ECommerceConverter {

    private static final String SHOW_SCREEN_EVENT = "show_screen_event";
    private static final String SHOW_PRODUCT_CARD_EVENT = "show_product_card_event";
    private static final String SHOW_PRODUCT_DETAILS_EVENT = "show_product_details_event";
    private static final String ADD_CART_ITEM_EVENT = "add_cart_item_event";
    private static final String REMOVE_CART_ITEM_EVENT = "remove_cart_item_event";
    private static final String BEGIN_CHECKOUT_EVENT = "begin_checkout_event";
    private static final String PURCHASE_EVENT = "purchase_event";

    @Nullable
    public static ECommerceEvent toNative(@NonNull final Pigeon.ECommerceEventPigeon pigeon) {
        switch (pigeon.getEventType()) {
            case SHOW_SCREEN_EVENT: {
                final Pigeon.ECommerceScreenPigeon screenPigeon = pigeon.getScreen();
                if (screenPigeon != null) {
                    return ECommerceEvent.showScreenEvent(
                        toNative(screenPigeon)
                    );
                }
                return null;
            }
            case SHOW_PRODUCT_CARD_EVENT: {
                final Pigeon.ECommerceProductPigeon productPigeon = pigeon.getProduct();
                final Pigeon.ECommerceScreenPigeon screenPigeon = pigeon.getScreen();
                if (productPigeon != null && screenPigeon != null) {
                    return ECommerceEvent.showProductCardEvent(
                        toNative(productPigeon),
                        toNative(screenPigeon)
                    );
                }
                return null;
            }
            case SHOW_PRODUCT_DETAILS_EVENT: {
                final Pigeon.ECommerceProductPigeon productPigeon = pigeon.getProduct();
                final Pigeon.ECommerceReferrerPigeon referrerPigeon = pigeon.getReferrer();
                final ECommerceReferrer referrer;
                if (referrerPigeon != null) {
                    referrer = toNative(referrerPigeon);
                } else {
                    referrer = null;
                }
                if (productPigeon != null) {
                    return ECommerceEvent.showProductDetailsEvent(
                        toNative(productPigeon),
                        referrer
                    );
                }
                return null;
            }
            case ADD_CART_ITEM_EVENT: {
                final Pigeon.ECommerceCartItemPigeon cartItemPigeon = pigeon.getCartItem();
                if (cartItemPigeon != null) {
                    return ECommerceEvent.addCartItemEvent(
                        toNative(cartItemPigeon)
                    );
                }
                return null;
            }
            case REMOVE_CART_ITEM_EVENT: {
                final Pigeon.ECommerceCartItemPigeon cartItemPigeon = pigeon.getCartItem();
                if (cartItemPigeon != null) {
                    return ECommerceEvent.removeCartItemEvent(
                        toNative(cartItemPigeon)
                    );
                }
                return null;
            }
            case BEGIN_CHECKOUT_EVENT: {
                final Pigeon.ECommerceOrderPigeon orderPigeon = pigeon.getOrder();
                if (orderPigeon != null) {
                    return ECommerceEvent.beginCheckoutEvent(
                        toNative(orderPigeon)
                    );
                }
                return null;
            }
            case PURCHASE_EVENT: {
                final Pigeon.ECommerceOrderPigeon orderPigeon = pigeon.getOrder();
                if (orderPigeon != null) {
                    return ECommerceEvent.purchaseEvent(
                        toNative(orderPigeon)
                    );
                }
                return null;
            }
        }
        return null;
    }

    @NonNull
    private static ECommerceScreen toNative(@NonNull final Pigeon.ECommerceScreenPigeon pigeon) {
        final ECommerceScreen result = new ECommerceScreen();
        result.setName(pigeon.getName());
        result.setSearchQuery(pigeon.getSearchQuery());
        result.setCategoriesPath(pigeon.getCategoriesPath());
        result.setPayload(pigeon.getPayload());
        return result;
    }

    @NonNull
    private static ECommerceProduct toNative(@NonNull final Pigeon.ECommerceProductPigeon pigeon) {
        final ECommerceProduct result = new ECommerceProduct(pigeon.getSku());
        result.setName(pigeon.getName());
        result.setCategoriesPath(pigeon.getCategoriesPath());
        result.setPayload(pigeon.getPayload());

        final Pigeon.ECommercePricePigeon actualECommercePricePigeon = pigeon.getActualPrice();
        final ECommercePrice actualECommercePrice;
        if (actualECommercePricePigeon != null) {
            actualECommercePrice = toNative(actualECommercePricePigeon);
        } else {
            actualECommercePrice = null;
        }
        result.setActualPrice(actualECommercePrice);

        final Pigeon.ECommercePricePigeon originalECommercePricePigeon = pigeon.getOriginalPrice();
        final ECommercePrice originalECommercePrice;
        if (originalECommercePricePigeon != null) {
            originalECommercePrice = toNative(originalECommercePricePigeon);
        } else {
            originalECommercePrice = null;
        }
        result.setOriginalPrice(originalECommercePrice);

        result.setPromocodes(pigeon.getPromocodes());
        return result;
    }

    @NonNull
    private static ECommerceAmount toNative(@NonNull final Pigeon.ECommerceAmountPigeon pigeon) {
        return new ECommerceAmount(
            new BigDecimal(pigeon.getAmount()),
            pigeon.getCurrency()
        );
    }

    @NonNull
    private static ECommercePrice toNative(@NonNull final Pigeon.ECommercePricePigeon pigeon) {
        final ECommercePrice result = new ECommercePrice(toNative(pigeon.getFiat()));

        final List<Pigeon.ECommerceAmountPigeon> internalComponentsPigeon = pigeon.getInternalComponents();
        if (internalComponentsPigeon != null) {
            final List<ECommerceAmount> internalComponents = new ArrayList<>();
            for (final Pigeon.ECommerceAmountPigeon eCommerceAmountPigeon : internalComponentsPigeon) {
                internalComponents.add(toNative(eCommerceAmountPigeon));
            }
            result.setInternalComponents(internalComponents);
        }

        return result;
    }

    @NonNull
    private static ECommerceReferrer toNative(@NonNull final Pigeon.ECommerceReferrerPigeon pigeon) {
        final ECommerceReferrer result = new ECommerceReferrer();
        result.setType(pigeon.getType());
        result.setIdentifier(pigeon.getIdentifier());

        final Pigeon.ECommerceScreenPigeon eCommerceScreenPigeon = pigeon.getScreen();
        final ECommerceScreen eCommerceScreen;
        if (eCommerceScreenPigeon != null) {
            eCommerceScreen = toNative(eCommerceScreenPigeon);
        } else {
            eCommerceScreen = null;
        }
        result.setScreen(eCommerceScreen);

        return result;
    }

    @NonNull
    private static ECommerceCartItem toNative(@NonNull final Pigeon.ECommerceCartItemPigeon pigeon) {
        final ECommerceCartItem result = new ECommerceCartItem(
            toNative(pigeon.getProduct()),
            toNative(pigeon.getRevenue()),
            new BigDecimal(pigeon.getQuantity())
        );

        final Pigeon.ECommerceReferrerPigeon eCommerceReferrerPigeon = pigeon.getReferrer();
        final ECommerceReferrer eCommerceReferrer;
        if (eCommerceReferrerPigeon != null) {
            eCommerceReferrer = toNative(eCommerceReferrerPigeon);
        } else {
            eCommerceReferrer = null;
        }
        result.setReferrer(eCommerceReferrer);

        return result;
    }

    @NonNull
    private static ECommerceOrder toNative(@NonNull final Pigeon.ECommerceOrderPigeon pigeon) {
        final List<ECommerceCartItem> items = new ArrayList<>();
        for (final Pigeon.ECommerceCartItemPigeon cartItemPigeon: pigeon.getItems()) {
            items.add(toNative(cartItemPigeon));
        }
        final ECommerceOrder result = new ECommerceOrder(
            pigeon.getIdentifier(),
            items
        );
        result.setPayload(pigeon.getPayload());

        return result;
    }
}
