import 'http_client.dart';
/// 用户
class UserAPI {
  /// 登录
  static Future<Map<String,dynamic>> login({
    UserLoginEntity? params,
  }) async {
    return await HttpUtil.POST(
      '/api/v3/user/session',
      payload: params?.toJson(),
    );
  }
}
// 登录请求参数
class UserLoginEntity {
  String email;
  String password;

  UserLoginEntity({
    required this.email,
    required this.password,
  });

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginEntity(
        email: json["userName"],
        password: json["Password"],
      );

  Map<String, dynamic> toJson() => {
    'userName': email,
    'Password': password,
  };
}


class User {
  String id = '';
  String userName = '';
  String nickname = '';
  int status = 0;
  String avatar = '';
  String createdAt = '';
  String preferredTheme = '';
  bool anonymous = false;
  Policy policy = Policy();
  Group group = Group();

  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    nickname = json['nickname'];
    status = json['status'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
    preferredTheme = json['preferred_theme'];
    anonymous = json['anonymous'];
    policy = (json['policy'] != null ? new Policy.fromJson(json['policy']) : null)!;
    group = (json['group'] != null ? new Group.fromJson(json['group']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['nickname'] = this.nickname;
    data['status'] = this.status;
    data['avatar'] = this.avatar;
    data['created_at'] = this.createdAt;
    data['preferred_theme'] = this.preferredTheme;
    data['anonymous'] = this.anonymous;
    if (this.policy != null) {
      data['policy'] = this.policy.toJson();
    }
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    return data;
  }
}

class Policy {
  String saveType = '';
  String maxSize = '';
  //List<Null> allowedType;
  String upUrl ='';
  bool allowSource = false;

  Policy();

  Policy.fromJson(Map<String, dynamic> json) {
    saveType = json['saveType'];
    maxSize = json['maxSize'];
    upUrl = json['upUrl'];
    allowSource = json['allowSource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saveType'] = this.saveType;
    data['maxSize'] = this.maxSize;
    data['upUrl'] = this.upUrl;
    data['allowSource'] = this.allowSource;
    return data;
  }
}

class Group {
  int id=0;
  String name='';
  bool allowShare=false;
  bool allowRemoteDownload=false;
  bool allowArchiveDownload=false;
  bool shareDownload=false;
  bool compress=false;
  bool webdav=false;

  Group();

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    allowShare = json['allowShare'];
    allowRemoteDownload = json['allowRemoteDownload'];
    allowArchiveDownload = json['allowArchiveDownload'];
    shareDownload = json['shareDownload'];
    compress = json['compress'];
    webdav = json['webdav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['allowShare'] = this.allowShare;
    data['allowRemoteDownload'] = this.allowRemoteDownload;
    data['allowArchiveDownload'] = this.allowArchiveDownload;
    data['shareDownload'] = this.shareDownload;
    data['compress'] = this.compress;
    data['webdav'] = this.webdav;
    return data;
  }
}