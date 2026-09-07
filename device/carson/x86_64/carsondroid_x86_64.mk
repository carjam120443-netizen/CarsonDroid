$(call inherit-product, device/google/cuttlefish/vsoc_x86_64/phone/aosp_cf.mk)

PRODUCT_NAME := carsondroid_x86_64
PRODUCT_DEVICE := vsoc_x86_64
PRODUCT_MANUFACTURER := CarsonDroid
PRODUCT_MODEL := CarsonDroid x86_64
PRODUCT_BRAND := CarsonDroid
PRODUCT_SYSTEM_NAME := CarsonDroid

PRODUCT_PACKAGES += \
    CarsonSettings \
    CarsonLauncher \
    CarsonFiles \
    RebootCenter

PRODUCT_VENDOR_PROPERTIES += \
    ro.carsondroid.version=0.1.0-dev \
    ro.carsondroid.device=x86_64 \
    ro.carsondroid.release=17

PRODUCT_PRODUCT_PROPERTIES += \
    ro.product.brand=CarsonDroid \
    ro.product.manufacturer=CarsonDroid \
    ro.product.model=CarsonDroid x86_64
