import 'package:nb_utils/nb_utils.dart';
import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../category/model/all_category_model.dart';

class ServiceFormApis {
  static Future<BaseResponseModel> removeService({required int serviceId}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.deleteService}?id=$serviceId' )));
  }

  static Future<CategoryListRes> getCategory() async {
    return CategoryListRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getCategoryList )));
  }

  static Future<BaseResponseModel> updateServicesStatus({required int serviceId, required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.updateClinicService}/$serviceId", request: request, method: HttpMethodType.POST)));
  }
}
