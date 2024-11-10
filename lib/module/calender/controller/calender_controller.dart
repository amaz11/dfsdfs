import 'package:get/get.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/calender/model/yearly_calender_model.dart';
import 'package:trealapp/module/calender/repo/calender_repo.dart';

class CalenderController extends GetxController {
  CalenderRepo? holidayRepo;
  CalenderController({this.holidayRepo});

  var data = Rxn<Data>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    try {
      isLoading(true);
      // Fetch from repo
      Response response = await holidayRepo!.getAllHoliday();

      if (response.statusCode == 200) {
        // print(response.body["data"]);
        YearlyCalenderModel holiday;
        holiday = YearlyCalenderModel.fromJson(response.body);
        data.value = holiday.data;
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to load holidays");
    } finally {
      isLoading(false);
    }
  }
}
