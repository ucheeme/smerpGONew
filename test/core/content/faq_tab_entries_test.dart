import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/content/faq_tab_entries.dart';

void main() {
  const faqs = [
    'What is Smerp Go?',
    'How to View all sales records?',
    'How to record a new sale?',
    'How to edit a sale?',
    'How to delete a sale?',
    'How to print a sale receipt?',
    'How to add a new product?',
    'How to view all product?',
    'How to edit a product?',
    'What is catalog?',
    'How does catalogue work?',
    'How to download reports?',
    'How can I add or edit my information?',
    'How can I delete my account?',
  ];

  test('faq tabs keep expected item counts', () {
    expect(FaqTabEntries.all(faqs).length, 14);
    expect(FaqTabEntries.sales(faqs).length, 5);
    expect(FaqTabEntries.inventory.length, 5);
    expect(FaqTabEntries.catalog.length, 2);
    expect(FaqTabEntries.report.length, 1);
    expect(FaqTabEntries.account.length, 2);
    expect(FaqTabEntries.order.length, 3);
  });

  test('faq expansion indices stay within supported range', () {
    final indices = [
      ...FaqTabEntries.all(faqs),
      ...FaqTabEntries.sales(faqs),
      ...FaqTabEntries.inventory,
      ...FaqTabEntries.catalog,
      ...FaqTabEntries.report,
      ...FaqTabEntries.account,
      ...FaqTabEntries.order,
    ].map((entry) => entry.expansionIndex);

    expect(
      indices.every(
        (index) => index >= 0 && index < FaqTabEntries.expansionStateCount,
      ),
      isTrue,
    );
  });
}
