# dazzle_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

received_orders
└── <user_uid> (document)
├── userData: { name, phone, addressLine1, addressLine2, city, state, postalCode, updatedAt }
└── orders (subcollection)
└── <user_uid_timestamp> (document)
├── userId
├── items: [
│     { productId, productNumber, name, photo, price, quantity, moq, weight }
│   ]
├── subtotal
├── deliveryCharge
├── gst
├── totalAmount
├── createdAt
├── status