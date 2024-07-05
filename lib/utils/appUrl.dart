import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';

import '../main.dart';

class AppUrls {
  String getActionBy(String value) {
    actionBy = value;
    return value;
  }

  static const rawBaseUrl =
      isProduction ? "finedgeapi.trustbancgroup.com" : "41.78.157.215";
  static const baseUrl =
      isProduction ? "https://devgo.smerp.io" : "http://41.78.157.215/SMERPGO";
  static const createAccount = baseUrl + "/api/Authn/CreateAccount";
  static const signUpToken = baseUrl + "/api/Authn/SignupToken";
  static const sendToken = baseUrl + "/api/Authn/SendToken";
  static const signUpTokenValidation =
      "$baseUrl/api/Authn/SignupTokenValidation";
  static const signUpPin = "$baseUrl/api/Authn/SignupPIN";
  String loginUser = "$baseUrl/api/Authn/Login";
  static const signInUser = "$baseUrl/api/Authn/SignInUser";
  static const authenticateDevice = "$baseUrl/api/Authn/DeviceLink";
  static const forgotPinToken = "$baseUrl/api/Authn/SendToken";
  static const resetPin = "$baseUrl/api/Authn/ResetPIN";
  static const createProductCategory = "$baseUrl/api/Product/ProductCategory";
  static const createProductUnitCategory = "$baseUrl/api/Product/ProductUnitCategory";
  String getAllOrders =
      "$baseUrl/api/Shopping/Order?merchantCode=${loginData?.merchantCode}";

  String getOrderDetails(String orderId) {
    var getDetails =
        "$baseUrl/api/Shopping/OrderDetails/$orderId?merchantCode=${loginData?.merchantCode}";
    return getDetails;
  }

  String  productCategory(String merchantCode) {
   var category= "$baseUrl/api/Product/ProductCategory?merchantCode=$merchantCode";
    return category;
  }
  String  productUnitCategory(String merchantCode) {
    var category= "$baseUrl/api/Product/ProductUnitCategory?merchantCode=$merchantCode";
    return category;
  }
    String orderConfirmation = "$baseUrl/api/Shopping/OrderConfirmation";
    String orderDeliveryConfirmation =
        "$baseUrl/api/Shopping/DeliveryConfirmation";
    String getProductInventory =
        "$baseUrl/api/Product/Inventory?userId=${loginData?.userId}";
    String getNotificationList= "$baseUrl/api/Notifications?userId=${loginData?.userId}";
  String getBankDetails= "$baseUrl/api/Profile/BankDetails/${loginData?.userId}";
  String createBankDetail= "$baseUrl/api/Profile/BankDetails";
    String getInventoryCount =
        "$baseUrl/api/Product/InventoryCountValue?userId=${loginData?.userId}";
    String getSalesDashboard =
        "$baseUrl/api/Dashboard/SalesSummary?userId=${loginData?.userId}";
    String getCatalogListAsShownToUsers =
        "$baseUrl/api/Catalogue/ProductInStock/${loginData?.userId}";
    String getCatalogList = "$baseUrl/api/Catalogue/Stock/${loginData?.userId}";

    //static var getProductInventoryDetail = "$baseUrl/api/Product/Inventory/$inventoryId?userId=${loginData?.userId}";
    static const productInventory = "$baseUrl/api/Product/Inventory";
    static const saleItem = "$baseUrl/api/Sales/Item";
    String getSaleItem = "$baseUrl/api/Sales/Item/?userId=${loginData?.userId}";
    static var updateProfileName = "$baseUrl/api/Profile/ProfileName";
    String getOtpToChangeUserInfoMailPhone =
        "$baseUrl/api/Authn/ChangeBusinessContact?userId=${loginData?.userId}";
    String validateOtpToChangeUserInfoMailPhone =
        "$baseUrl/api/Authn/ConfirmBusinessContact?userId=${loginData?.userId}";

    static var updateProfileImage = "$baseUrl/api/Profile/ProfileImage";
    String userProfileInfo =
        "$baseUrl/api/Profile/ProfileInformation?userId=${loginData?.userId}";
    String getInventorysummary =
        "$baseUrl/api/Dashboard/InventorySummary?userId=${loginData?.userId}";
    String deleteAccount =
        "$baseUrl/api/Profile/ProfileDelete?userId=${loginData?.userId}";
    static var updateInventoryStock = "$baseUrl/api/Product/StockUp";

    String getProductInventoryDetail(String inventoryId) {
      var getInventoryDetails =
          "$baseUrl/api/Product/Inventory/$inventoryId?userId=${loginData?.userId}";
      return getInventoryDetails;
    }

    static String orderCancel(String orderId){
      http://41.78.157.215/SMERPGo/api/Shopping/OrderCancellation/01HBAVDEKT5QPH1GPYEMRAX84G?merchantCode=23aX249207
      String cancelCustomerOrder = "$baseUrl/api/Shopping/OrderCancellation/$orderId?merchantCode=${loginData?.merchantCode}";
      return cancelCustomerOrder;
    }
    static String deleteProductInventoryDetail(String inventoryId, String inventoryName) {
      var getInventoryDetails = "$baseUrl/api/Product/Inventory/"
          "$inventoryId?productName=$inventoryName";
      return getInventoryDetails;
    }

    static String deleteSaleRecord(String saleId,) {
      var deleteRecord = "$baseUrl/api/Sales/Item/""$saleId";
      return deleteRecord;
    }

    static String orderHistory(){
      var getOrderHistory ="$baseUrl/api/Shopping/OrderHistory?userId=${loginData?.userId}";
      return getOrderHistory;
    }

    static String updateProductInventoryDetail(String inventoryId) {
      var getInventoryDetails = "$baseUrl/api/Product/Inventory/$inventoryId";
      return getInventoryDetails;
    }

    static String updateSaleRecord(String saleId) {
      var updateRecord = "$baseUrl/api/Sales/Item/"
          "$saleId";
      return updateRecord;
    }

  static String updateAllSaleItemToPaid(String saleId) {
    var updateRecord = "$baseUrl/api/Sales/Items/"
        "$saleId";
    return updateRecord;
  }

    static String deleteItemOnSale(int saleId, int saleItemId) {
      var updateRecord = "$baseUrl/api/Sales/Item/"
          "$saleId/$saleItemId";
      return updateRecord;
    }

    String updateCatalogProductRecord(int prodId, bool isShow) {
      var updateRecord =
          "$baseUrl/api/Catalogue/Stock/${loginData?.userId}?productId=$prodId&IsShow=$isShow";
      return updateRecord;
    }

    String updateCatalogProductAtCategoryRecord(int categoryId, bool isShow) {
      var updateRecord =
          "$baseUrl/api/Catalogue/AllStockByCategory?userId=${loginData?.userId}&"
          "categoryId=$categoryId&IsShow=$isShow";
      return updateRecord;
    }

    String updateAllProductCatalogView(bool isShow) {
      var update =
          "$baseUrl/api/Catalogue/AllStock?userId=${loginData?.userId}&IsShow=$isShow";
      return update;
    }

    String saleFilterByDate(DateTime startDate, DateTime endDate) {
      var update =
          "$baseUrl/api/Report/Sales/${loginData?.userId}?FromDate=$startDate&ToDate=$endDate";
      return update;
    }

    String reportByMonth(int year, int month) {
      var update =
          "$baseUrl/api/Report/SalesMonth/${loginData?.userId}/$year/$month";
      return update;
    }

    String reportByWeek() {
      var update = "$baseUrl/api/Report/SalesWeek/${loginData?.userId}";
      return update;
    }

    String reportByTear(String year) {
      var update = "$baseUrl/api/Report/Sales/${loginData?.userId}/$year";
      return update;
    }

    String getSaleDetails(int saleId) {
      var response =
          "$baseUrl/api/Sales/Item/$saleId?userId=${loginData?.userId}";
      return response;
    }

  //Collection Urls
  String getUserCollections(String merchantCode) {
    var collections = "$baseUrl/api/Collections?merchantCode=$merchantCode";
    return collections;
  }

  static var createCollectionUrl ="$baseUrl/api/Collections";
  String getCollectionDetails(String merchantCode, String collectionId){
    var collections ="$baseUrl/api/Collections/$merchantCode/$collectionId";
    return collections;
  }

  String deleteCollection(String collectionId){
    var collections ="$baseUrl/api/Collections/$collectionId";
    return collections;
  }
  String updateCollectionDetail(String collectionId){
    var collections ="$baseUrl/api/Collections?collectionsId=$collectionId";
    return collections;
  }



/// Report Apis
 String salesAnalysis(int filterPeriod){
    var sales = "$baseUrl/api/Report/SalesAnalysis/${loginData?.userId}/"
        "$filterPeriod";
    return sales;
 }

  String salesAnalysisRange(int filterPeriod,String fromDate, String toDate){
    var sales = "$baseUrl/api/Report/SalesAnalysis/${loginData?.userId}?"
        "fromDate=$fromDate&toDate=$toDate";
    return sales;
  }

  String productAnalysisRange(int filterPeriod,String fromDate, String toDate){
    var product = "$baseUrl/api/Report/ProductsAnalysis/${loginData?.userId}?"
        "fromDate=$fromDate&toDate=$toDate";
    return product;
  }

  String productAnalysis(int filterPeriod){
    var productA = "$baseUrl/api/Report/ProductsAnalysis/${loginData?.userId}/"
        "$filterPeriod";
    return productA;
  }
  String performingProductAnalysis(){
    var products = "$baseUrl/api/Report/PerformingAnalysis/${loginData?.userId}";
    return products;
  }

  String downloadReportData(String saleType, String period,String type){
    var result="$baseUrl/api/Report/Download/${loginData?.userId}/$saleType/$period?type=$type";
    return result;
  }

  String downloadReportDataRange(String saleType, String startDate, String endDate,String type){
    var result="$baseUrl/api/Report/Download/${loginData?.userId}/$saleType?type=$type&fromDate=$startDate"
        "&toDate=$endDate";
    return result;
  }

  }

