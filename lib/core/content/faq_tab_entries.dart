class FaqEntry {
  const FaqEntry({
    required this.question,
    required this.answer,
    required this.expansionIndex,
  });

  final String question;
  final String answer;
  final int expansionIndex;
}

class FaqTabEntries {
  FaqTabEntries._();

  static const expansionStateCount = 23;

  static List<FaqEntry> all(List<String> faqs) => [
        FaqEntry(
          question: 'Q:${faqs[0]}',
          answer:
              'A: Smerp Go is a lite version of SMERP which is a cloud-based ERP solution. \n'
              'Smerp Go helps you keep records of your sales and inventory, gives a report on your records and provides '
              'you with a website to display your available products. ',
          expansionIndex: 0,
        ),
        FaqEntry(
          question: 'Q: ${faqs[1]}',
          answer:
              'A: On the home screen, click add new sale. Fill in the details of the new sale; \n'
              'enter product, enter quantity, enter the units of the product (which is how '
              'the product is measured), enter the payment status, click add sale.',
          expansionIndex: 1,
        ),
        FaqEntry(
          question: 'Q: ${faqs[2]}',
          answer:
              'A: On the home screen, click on the edit icon for the sale you’d like to edit.',
          expansionIndex: 2,
        ),
        FaqEntry(
          question: 'Q: ${faqs[3]}',
          answer:
              'A: On the home screen, click on the delete icon for the sale you’d like to delete',
          expansionIndex: 3,
        ),
        FaqEntry(
          question: 'Q:${faqs[4]}',
          answer:
              'A: On the home screen, click on the receipt icon for the sale you’d like to see the receipt.',
          expansionIndex: 4,
        ),
        FaqEntry(
          question: 'Q: ${faqs[5]}',
          answer:
              'A: On the home screen, click on the receipt icon for the sale you’d like to see the receipt.',
          expansionIndex: 5,
        ),
        FaqEntry(
          question: 'Q: ${faqs[6]}',
          answer:
              'A: On the Inventory screen, click add new product. Fill in the details of the new product; \n'
              'enter product name, enter product image, enter product category, enter product selling \n'
              'price, enter product selling price, enter quantity, enter the units of the product \n'
              '(which is how the product is measured), click add product',
          expansionIndex: 6,
        ),
        FaqEntry(
          question: 'Q:${faqs[7]}',
          answer:
              'A: On the home screen, click on the edit icon for the sale you’d like to edit.',
          expansionIndex: 7,
        ),
        FaqEntry(
          question: 'Q: ${faqs[8]}',
          answer: '',
          expansionIndex: 8,
        ),
        FaqEntry(
          question: 'Q: ${faqs[9]}',
          answer:
              'A: On the inventory screen, click on the delete icon for the product you’d like to delete.',
          expansionIndex: 9,
        ),
        FaqEntry(
          question: 'Q: ${faqs[10]}',
          answer: '',
          expansionIndex: 10,
        ),
        FaqEntry(
          question: 'Q: ${faqs[11]}',
          answer: '',
          expansionIndex: 11,
        ),
        FaqEntry(
          question: 'Q: ${faqs[12]}',
          answer:
              'A:Click on the profile icon in the top left corner on any screen, \n'
              'click personal data, you can edit your first name, last name, store name, email and phone number. Click on update info',
          expansionIndex: 12,
        ),
        FaqEntry(
          question: 'Q:${faqs[13]}',
          answer:
              'A: Click on the profile icon in the top left corner on any screen, \n'
              'click on delete account, enter pin to delete account, click confirm.',
          expansionIndex: 13,
        ),
      ];

  static List<FaqEntry> sales(List<String> faqs) => [
        FaqEntry(
          question: 'Q: ${faqs[1]}',
          answer:
              'A: On the home screen, click add new sale. Fill in the details of the new sale; \n'
              'enter product, enter quantity, enter the units of the product (which is how '
              'the product is measured), enter the payment status, click add sale.',
          expansionIndex: 1,
        ),
        FaqEntry(
          question: 'Q:  ${faqs[2]}',
          answer:
              'A: On the home screen, click see records, you can filter by date or'
              ' transaction status.',
          expansionIndex: 2,
        ),
        FaqEntry(
          question: 'Q:${faqs[3]}',
          answer:
              'A: On the home screen, click on the edit icon for the sale you’d like to edit.',
          expansionIndex: 7,
        ),
        FaqEntry(
          question: 'Q: ${faqs[4]}',
          answer:
              'A: On the home screen, click on the delete icon for the sale you’d like to delete',
          expansionIndex: 8,
        ),
        FaqEntry(
          question: 'Q: ${faqs[5]}',
          answer:
              'A: On the home screen, click on the receipt icon for the sale you’d like to see the receipt.',
          expansionIndex: 9,
        ),
      ];

  static List<FaqEntry> inventory = const [
        FaqEntry(
          question: 'Q: How do I add products on the Smerp app?',
          answer:
              'A: Go to Products, add new products, fill in the details e.g. Product name, type, description, '
              'image etc. and you are good to go.',
          expansionIndex: 3,
        ),
        FaqEntry(
          question: 'Q: How to Add a New Product?',
          answer:
              'A: On the Inventory screen, click add new product. Fill in the details of the new product; \n'
              'enter product name, enter product image, enter product category, enter product selling \n'
              'price, enter product selling price, enter quantity, enter the units of the product \n'
              '(which is how the product is measured), click add product',
          expansionIndex: 11,
        ),
        FaqEntry(
          question: 'Q: How to View all Products?',
          answer:
              'A: On the inventory screen, click inventory records, you can filter by date or category',
          expansionIndex: 12,
        ),
        FaqEntry(
          question: 'Q: How to Edit a Product',
          answer:
              'A: On the inventory screen, click on the edit icon for the product you’d like to edit.',
          expansionIndex: 13,
        ),
        FaqEntry(
          question: 'Q: How to Delete a Product',
          answer:
              'A: On the inventory screen, click on the delete icon for the product you’d like to delete.',
          expansionIndex: 14,
        ),
      ];

  static List<FaqEntry> catalog = const [
        FaqEntry(
          question: 'Q: What is Catalogue?',
          answer:
              'A: Smerp Go gives you a website for your customers to have access to your products listing, this is called catalogue',
          expansionIndex: 15,
        ),
        FaqEntry(
          question: 'Q: How does Catalogue work?',
          answer:
              'A: On the catalogue screen, select which products you’d like to show available on your website by toggling them on/off.',
          expansionIndex: 16,
        ),
      ];

  static List<FaqEntry> report = const [
        FaqEntry(
          question: 'Q: How to Download Reports?',
          answer:
              'A: On the reports screen, select the range of the report, click download report.',
          expansionIndex: 17,
        ),
      ];

  static List<FaqEntry> account = const [
        FaqEntry(
          question: 'Q: How can I add or edit my information?',
          answer:
              'A:Click on the profile icon in the top left corner on any screen, \n'
              'click personal data, you can edit your first name, last name, store name, email and phone number. Click on update info',
          expansionIndex: 18,
        ),
        FaqEntry(
          question: 'Q: How can I delete my account?',
          answer:
              'A: Click on the profile icon in the top left corner on any screen, \n'
              'click on delete account, enter pin to delete account, click confirm.',
          expansionIndex: 19,
        ),
      ];

  static List<FaqEntry> order = const [
        FaqEntry(
          question: 'Q: How can I accept or reject order?',
          answer:
              'A:Click on the order you received, when the bottom-sheet shows, select any of the options you want., \n',
          expansionIndex: 20,
        ),
        FaqEntry(
          question: 'Q: How can I cancel an order?',
          answer:
              'A: Click on the order you accepted when the bottom-sheet opens up, \n'
              'click on cancel order.',
          expansionIndex: 21,
        ),
        FaqEntry(
          question: 'Q: How can I update the payment of an order?',
          answer:
              'A: Click on the pen icon on the order you accepted, \n'
              'You will be taken to a new screen on the screen enter the delivery code sent to your customer \n'
              'select the payment status and click on Update payment status',
          expansionIndex: 22,
        ),
      ];
}
