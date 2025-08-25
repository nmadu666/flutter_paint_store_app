import 'package:collection/collection.dart';
import 'package:flutter_paint_store_app/data/mock_data.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteNotifier - Customer Management', () {
    late ProviderContainer container;
    late List<Customer> initialCustomers;

    setUp(() {
      // Override providers to ensure a fresh state for each test.
      // This is a best practice for robust testing.
      container = ProviderContainer(overrides: [
        customersProvider.overrideWith((ref) => CustomersNotifier()),
      ]);
      addTearDown(container.dispose);
      initialCustomers = mockCustomers.toList(); // Create a copy for comparison
    });

    test('initial state should select the first customer and first price list',
        () {
      // Arrange & Act
      final quote = container.read(quoteProvider);
      final firstCustomer = container.read(customersProvider).first;
      final firstPriceList = container.read(priceListsProvider).first;

      // Assert
      expect(quote.customer, firstCustomer);
      expect(quote.priceList, firstPriceList);
    });

    test('selectCustomer should update the customer in the current quote', () {
      // Arrange
      final notifier = container.read(quoteProvider.notifier);
      final secondCustomer = container.read(customersProvider)[1];

      // Act
      notifier.selectCustomer(secondCustomer);

      // Assert
      final selectedCustomer = container.read(selectedCustomerProvider);
      expect(selectedCustomer, secondCustomer);
    });

    test(
        'addCustomerAndSelect should add a new customer and select it for the quote',
        () {
      // Arrange
      final notifier = container.read(quoteProvider.notifier);
      final newCustomer = Customer(
        id: 99, // Changed to int
        name: 'New Customer',
        code: 'NEW001',
        gender: true,
        birthDate: null,
        contactNumber: '0123456789',
        address: '123 New Street',
        locationName: 'Test Location',
        wardName: 'Test Ward',
        email: 'new@example.com',
        organization: 'New Org',
        comments: 'Test comment',
        taxCode: '12345',
        retailerId: 1,
        debt: 0.0,
        totalInvoiced: 0.0,
        totalPoint: 0.0,
        totalRevenue: 0.0,
        modifiedDate: null,
        createdDate: DateTime.now(), // Added required field
      );

      // Act
      notifier.addCustomerAndSelect(newCustomer);

      // Assert
      final updatedCustomers = container.read(customersProvider);
      final selectedCustomer = container.read(selectedCustomerProvider);

      // Assert that the new customer is in the list
      expect(updatedCustomers, contains(newCustomer));
      expect(updatedCustomers.length, initialCustomers.length + 1);
      // Assert that the new customer is selected in the quote
      expect(selectedCustomer, newCustomer);
    });

    test('updateCustomer should update an existing customer in the list', () {
      // Arrange
      final notifier = container.read(quoteProvider.notifier);
      final originalCustomer =
          container.read(customersProvider)[1]; // Get 'Anh Sơn - Cầu Giấy'
      final updatedCustomer = originalCustomer.copyWith(
        name: 'Anh Sơn - Cầu Giấy (Updated)',
        contactNumber: '1111111111',
      );

      // Act
      notifier.updateCustomer(updatedCustomer);

      // Assert
      final updatedCustomers = container.read(customersProvider);
      final customerInList =
          updatedCustomers.firstWhere((c) => c.id == originalCustomer.id);

      // Assert the customer in the main list is updated
      expect(customerInList.name, 'Anh Sơn - Cầu Giấy (Updated)');
      expect(customerInList.contactNumber, '1111111111');
      // Assert the original customer object is no longer in the list
      expect(updatedCustomers, isNot(contains(originalCustomer)));
      expect(updatedCustomers.length, initialCustomers.length);
    });

    test(
        'updateCustomer should also update the selected customer if it is being edited',
        () {
      // Arrange
      final notifier = container.read(quoteProvider.notifier);
      final customerToSelectAndUpdate = container.read(customersProvider)[1];

      // Select this customer first
      notifier.selectCustomer(customerToSelectAndUpdate);
      expect(
          container.read(selectedCustomerProvider), customerToSelectAndUpdate);

      final updatedDetails = customerToSelectAndUpdate.copyWith(
        name: 'Anh Sơn - Edited',
      );

      // Act
      notifier.updateCustomer(updatedDetails);

      // Assert
      final finalSelectedCustomer = container.read(selectedCustomerProvider);
      final customerInList = container
          .read(customersProvider)
          .firstWhereOrNull((c) => c.id == updatedDetails.id);

      // Assert the selected customer in the quote is the updated one
      expect(finalSelectedCustomer, isNotNull);
      expect(finalSelectedCustomer, updatedDetails);
      expect(finalSelectedCustomer!.name, 'Anh Sơn - Edited');

      // Assert the customer in the main list is also updated
      expect(customerInList, isNotNull);
      expect(customerInList, updatedDetails);
    });
  });
}
