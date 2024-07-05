class MockInventory{

  MockInventory({
    required this.saleTitle,
    required this.totalCost,
    required this.qty,
    required this.category,
    required this.paymentStatus,
    required this.date
});
  String saleTitle;
  double totalCost;
  int    qty;
  String category;
  String paymentStatus;
  String date;
}

List<MockInventory> mockInventoryData=[
 
MockInventory(
  saleTitle:"Sony Playstation 5",
  totalCost: 300000.0,
  qty:1,
    category:"Carton",
  paymentStatus:"Paid",
  date: "29/09/2029"
),
MockInventory(
  saleTitle:"MacBook Pro ",
  totalCost: 800000.0,
  qty:7,
  category:"Carton",
  paymentStatus:"Pending",
   date:"1/08/2029"
),
   MockInventory(
  saleTitle:"MacBook Air",
  totalCost: 600000.0,
  qty:20,
  category:"Carton",
  paymentStatus:"Paid",
    date:"1/08/2029"
   ), MockInventory(
  saleTitle:"Sony Playstation 5",
  totalCost: 300000.0,
  qty:3,
  category:"Carton",
  paymentStatus:"Unpaid",
    date:"01/08/2029"
  ), MockInventory(
  saleTitle:"Samsung Ultra 23",
  totalCost: 900000.0,
  qty:3,
  category:"Carton",
  paymentStatus:"Paid",
    date:"20/02/2028"
  ), MockInventory(
  saleTitle:"Sony Playstation 5",
  totalCost: 300000.0,
  qty:1,
  category:"Carton",
  paymentStatus:"Paid",
    date:"20/02/2028"
  ), MockInventory(
  saleTitle:"Sony Playstation 5",
  totalCost: 300000.0,
  qty:1,
  category:"Carton",
  paymentStatus:"Paid",
    date:"23/05/2028"
  ),
  MockInventory(
    saleTitle:"Airpod Pro",
    totalCost: 450000.0,
    qty:9,
    category:"Carton",
    paymentStatus:"Paid",
    date:"20/02/2028"
  ),
    MockInventory(
    saleTitle:"Sony Playstation 5",
    totalCost: 300000.0,
    qty:1,
    category:"Carton",
    paymentStatus:"Paid",
    date:"04/07/2028"
    ),
    MockInventory(
    saleTitle:"XBox",
    totalCost: 300000.0,
    qty:14,
    category:"Carton",
    paymentStatus:"Paid",
    date:"20/02/2028"
    )
];