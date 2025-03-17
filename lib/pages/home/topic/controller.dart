import 'package:get/get.dart';

import '../../../logic/model/feed/datum.dart';
import '../../../logic/network/network_repo.dart';
import '../../../logic/state/loading_state.dart';
import '../../../pages/home/home_page.dart' show TabType;

class HomeTopicController extends GetxController with StateMixin<List<Datum>> {
  HomeTopicController({
    required this.tabType,
  });
  final TabType tabType;

  late RxInt currentIndex = (tabType == TabType.TOPIC ? 1 : 0).obs;

  void onReload() {
    change(GetStatus.loading());
    getData();
  }

  Future<void> getData() async {
    LoadingState<dynamic> response = await NetworkRepo.getDataListFromUrl(
        url: tabType == TabType.TOPIC
            ? '/v6/page/dataList?url=V11_VERTICAL_TOPIC&title=话题&page=1'
            : '/v6/product/categoryList');
    switch (response) {
      case Empty():
        change(GetStatus.empty());
      case Error():
        change(GetStatus.error(response.errMsg));
      case Success():
        change(GetStatus.success(response.response));
    }
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
