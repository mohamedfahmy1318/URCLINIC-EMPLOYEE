import 'package:nb_utils/nb_utils.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import 'model/city_list_response.dart';
import 'model/country_list_response.dart';
import 'model/state_list_response.dart';

class UserAddressesApis {
  static Future<List<CountryData>> getCountryList({String searchTxt = ''}) async {
    final String search = searchTxt.isNotEmpty ? 'search=$searchTxt' : '';
    final res = CountryListResponse.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.countryList}?$search" )));
    return res.data.validate();
  }

  static Future<List<StateData>> getStateList({required int countryId, String searchTxt = ''}) async {
    final String search = searchTxt.isNotEmpty ? '&search=$searchTxt' : '';
    final res = StateListResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.stateList}?country_id=$countryId$search' )));
    return res.data.validate();
  }

  static Future<List<CityData>> getCityList({required int stateId, String searchTxt = ''}) async {
    final String search = searchTxt.isNotEmpty ? '&search=$searchTxt' : '';
    final  res = CityListResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.cityList}?state_id=$stateId$search' )));
    return res.data.validate();
  }
}
