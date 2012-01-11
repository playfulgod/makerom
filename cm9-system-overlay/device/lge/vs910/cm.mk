#$(call inherit-product, device/lge/vs910/full_vs910.mk)
#

# Camera
PRODUCT_PACKAGES := \
    Camera

# Live Wallpapers
PRODUCT_PACKAGES += \
        LiveWallpapers \
        LiveWallpapersPicker \
        VisualizationWallpapers \
        librs_jni

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
# This is where we'd set a backup provider if we had one
#$(call inherit-product, device/sample/products/backup_overlay.mk)
$(call inherit-product, device/lge/vs910/device.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)

# Discard inherited values and use our own instead.

PRODUCT_RELEASE_NAME := VS90
#PRODUCT_RELEASE_NAME := NS

$(call inherit-product, vendor/cm/config/common_full_phone.mk)

#PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=sojus BUILD_ID=IML74K BUILD_FINGERPRINT=google/sojus/crespo4g:4.0.3/IML74K/239410:user/release-keys PRIVATE_BUILD_DESC="sojus-user 4.0.3 IML74K 239410 release-keys" BUILD_NUMBER=239410
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=cm_vs910 BUILD_ID=IML74K BUILD_FINGERPRINT=google/sojus/crespo4g:4.0.3/IML74K/239410:user/release-keys PRIVATE_BUILD_DESC="sojus-user 4.0.3 IML74K 239410 release-keys" BUILD_NUMBER=239410

PRODUCT_NAME := cm_vs910
PRODUCT_DEVICE := vs910
PRODUCT_BRAND := LG
PRODUCT_MODEL := Revolution
PRODUCT_MANUFACTURER := LGE

