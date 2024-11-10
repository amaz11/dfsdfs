import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class LeaveApprovalRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;

  LeaveApprovalRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getLeaveType() async {
    return await apiClient.getData(ApiRoute.leaveType);
  }

  Future<Response> getAllLeaveApprovalRequest() async {
    return await apiClient.getData(ApiRoute.leaveApprovalRequest);
  }

  Future<Response> getApproverAllLeaveApprovalRequest(int? approved) async {
    if (approved == null) {
      return await apiClient
          .getData("${ApiRoute.approverLeaveApprovalRequest}/");
    }
    return await apiClient.getData(
        "${ApiRoute.approverLeaveApprovalRequest}/?approved=$approved");
  }

  Future<Response> postleaveApprove(num id, Map<String, dynamic> data) async {
    return await apiClient.postData(
        "${ApiRoute.leaveApprovalRequest}/$id/approve", data);
  }
}
