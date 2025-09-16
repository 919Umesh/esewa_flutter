# Flutter eSewa Payment Gateway Integration

This Flutter project demonstrates how to integrate the eSewa payment gateway into a Flutter application for seamless payment processing.

## Overview

The project includes a working implementation of eSewa payment integration with a user-friendly interface. It comes with sample product images and a complete setup for testing payment functionality.

## Features

- eSewa payment gateway integration
- Product display with images
- Payment processing flow
- Sample product images included
- Clean and intuitive UI


## Setup Instructions

### 1. Add Dependencies

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  esewa_flutter_sdk: ^1.0.0
```

Then run:
```
flutter pub get
```

### 2. Configure Android Manifest

Add internet permission and intent filters in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />

<application>
    <!-- Other application configurations -->
    
    <activity
        android:name="com.esewa.android.sdk.payment.ESewaPaymentActivity"
        android:theme="@style/Theme.AppCompat.Light.DarkActionBar" />
</application>
```

### 3. iOS Configuration

For iOS, add the following in `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>esewa</string>
</array>
```

### 4. Import Assets

Ensure your assets are properly declared in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/photos/photo1.jpg
    - assets/photos/photo2.jpg
    - assets/photos/photo3.jpg
    - assets/photos/photo4.jpg
```

## Usage

### Initialize eSewa

```dart
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';

// Initialize eSewa configuration
final EsewaConfig _config = EsewaConfig(
  clientId: 'your_client_id',
  secretId: 'your_secret_key',
  environment: Environment.test, // Use .live for production
);
```

### Make Payment

```dart
// Create payment object
final EsewaPayment _payment = EsewaPayment(
  productId: 'product_id',
  productName: 'Product Name',
  productPrice: '100.0',
  callbackUrl: 'https://example.com/callback',
);

// Initiate payment
EsewaFlutterSdk.initPayment(
  config: _config,
  payment: _payment,
  onSuccess: (EsewaPaymentSuccess data) {
    // Handle payment success
    print('Payment Successful: ${data.message}');
  },
  onFailure: (EsewaPaymentFailure data) {
    // Handle payment failure
    print('Payment Failed: ${data.message}');
  },
  onCancellation: (EsewaPaymentCancellation data) {
    // Handle payment cancellation
    print('Payment Cancelled: ${data.message}');
  },
);
```

## Testing

For testing purposes, use the following test credentials:

- Client ID: `JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R`
- Secret Key: `BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==`
- Environment: `Environment.test`

Use these test payment details:
- Mobile Number: `9800000000`
- OTP: `123456`

## Important Notes

1. Replace test credentials with your actual production credentials before publishing
2. Handle payment verification on your server for security
3. Test thoroughly in both sandbox and live environments
4. Ensure proper error handling for network issues

## Troubleshooting

- If payment fails, check your internet connection
- Verify your client ID and secret key are correct
- Ensure callback URL is properly configured
- Check that all required permissions are set in AndroidManifest.xml and Info.plist

## Support

For issues related to eSewa integration, refer to the official [eSewa documentation](https://developer.esewa.com.np) or create an issue in this repository.

## License

This project is for educational purposes. Please ensure compliance with eSewa's terms of service when implementing in production applications.