import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/summary_count_model.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';

class SummeryCountController extends GetxController{
  bool _summeryCardInProgress =false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  bool get summeryCardInProgress=> _summeryCardInProgress;
  List<SummaryCountListData>? get summaryCountModel => _summaryCountModel.data;

  Future<void> getSummaryCount() async {
    _summeryCardInProgress =true;
    update();
    NetworkResponse response =
    await NetworkCalling().getRequest(Urls.taskStatusCount);
    _summeryCardInProgress =false;
    update();
    if (response.statusCode == 200) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
    }
  }

}