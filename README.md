# account_book

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firestore Constitution

- Collection: users
  - Document: [username]
    - Collection: datetime
      - Document: [yyyymmddhhmmss.xxx]
        - Data:
        - "type"
          - [income]
          - "date"
            - [yyyymmddhhmmss.xxx]
          - "store" (only spending)
            - [stonename]
          - "item"
            - [itemname]
          - "payment" (only spending)
            - [paymentmethod]
          - "amount"
            - [1000]
          - "detail"
            - [XXXXXXXXXX]
