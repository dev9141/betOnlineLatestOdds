import 'package:bet_online_latest_odds/data/entity/configuration_entity.dart';

class APIResponse {
  String message;
  bool success;
  dynamic response;
  Object? object;
  APIResponse(this.response, this.message, this.success, [this.object]);

/*\factory APIResponse.fromMap(Map<String, dynamic> json) {
    return APIResponse(,json.isEmpty ? S.current.err_msg : json["message"],
        json.isEmpty ? false : true);
  }*/
}
