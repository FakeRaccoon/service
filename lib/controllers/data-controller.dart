import 'package:get/get.dart';
import 'package:service/models/order-model.dart';
import 'package:service/models/part-model.dart';
import 'package:service/services/api.dart';

class DataController extends GetxController {
  final apiController = APIService();
  var dataList = [Order()].obs;

  var pageCount = 1.obs;
  var isLoading = true.obs;
  var hasMore = false.obs;

  void fetchData(status) async {
    await apiController.getOrder(page: 1).then((value) {
      dataList.value = value;
      isLoading(false);
    }, onError: (e) {
      print(e);
    });
  }

  void fetchMoreData({int? status}) async {
    final value = await apiController.getOrder(page: pageCount.value + 1);
    if (value.isEmpty) {
      hasMore.value = false;
    } else {
      pageCount++;
      hasMore.value = true;
      dataList.addAll(value);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
