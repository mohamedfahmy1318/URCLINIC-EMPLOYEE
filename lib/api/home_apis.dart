import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';
import '../network/network_utils.dart';
import '../screens/home/model/medicine_usage_chart_resp.dart';
import '../screens/home/model/revenue_resp.dart';
import '../utils/api_end_points.dart';
import '../screens/home/model/dashboard_res_model.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';

class HomeServiceApis {
  static Future<DashboardRes> getDashboard({int topSupplierLimit = 3}) async {
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) {
      return DashboardRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.vendorDashboardList)));
    } else if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) {
      return DashboardRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.pharmaDashboardList}?clinic_id=${selectedAppClinic.value.id}&top_supplier=$topSupplierLimit", method: HttpMethodType.GET)));
    } else if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
      return DashboardRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.doctorDashboardList}?clinic_id=${selectedAppClinic.value.id}")));
    } else {
      return DashboardRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.receptionistDashboardList)));
    }
  }

  static Future<RevenueResp> getRevenue() async {
    return RevenueResp.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.revenueDetails)));
  }

  static Future<MedicineUsageChartResp> getMedicineUsageChartData({String type = ""}) async {
    String typeStr = type.isNotEmpty ? 'type=$type' : 'type=weekly';
    DateTime now = DateTime.now();

    DateTime startDate;
    DateTime endDate;

    if (type == 'monthly') {
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0);
    } else {
      int currentWeekday = now.weekday;
      startDate = now.subtract(Duration(days: currentWeekday - 1));
      endDate = startDate.add(const Duration(days: 6));
    }

    String dateStr = '&start_date=${startDate.formatDateYYYYmmdd()}&end_date=${endDate.formatDateYYYYmmdd()}';
    String params = '?$typeStr$dateStr';
    log('params: $params');
    return MedicineUsageChartResp.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.medicineUsageChart}$params", method: HttpMethodType.GET)));
  }
}
