import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:file_picker/file_picker.dart';

class HttpUtil {

  static void init(String server){
    Uri uri = Uri.parse(server);
    _scheme = uri.scheme;
    _host = uri.host;
    _port = uri.port;
  }


  static final CookieJar cookieJar = CookieJar();
  static final HttpClient httpClient = HttpClient();

  static String _scheme = 'http';
  static String _host = '';
  static int _port = 5212;

  static Future<Map<String, String>> previewUrl(String id) async {
    Map<String,String> data = Map<String,String>();
    data['url'] =  'http://$_host:$_port/api/v3/file/preview/$id';
    List<Cookie> cookies = await cookieJar.loadForRequest(Uri(
      scheme: _scheme,
      host: _host,
      port: _port,
    ));
    String vs = '';
    cookies.forEach((e) {
      vs += '${e.name}=${e.value};';
    });
    data['Cookie'] = vs;
    return data;
  }

  static Future<Map<String, dynamic>> GET(String path,
      {Map<String, dynamic>? params}) async {
    Uri uri = Uri(
        scheme: _scheme,
        host: _host,
        port: _port,
        path: path,
        queryParameters: params);
    HttpClientRequest request = await httpClient.getUrl(uri);
    request.cookies.addAll(await cookieJar.loadForRequest(uri));
    // 获取返回数据
    HttpClientResponse response = await request.close();
    await cookieJar.saveFromResponse(uri, response.cookies);
    String responseBody = await response.transform(utf8.decoder).join();
    print('GET请求返回: $responseBody');
    Map<String, dynamic> data = json.decode(responseBody);
    return data;
  }

  static Future<Map<String, dynamic>> PUT(String path,
      {Map<String, dynamic>? params, Map<String, dynamic>? payload}) async {
    Uri uri = Uri(
        scheme: _scheme,
        host: _host,
        port: _port,
        path: path,
        queryParameters: params);
    HttpClientRequest request = await httpClient.putUrl(uri);
    request.cookies.addAll(await cookieJar.loadForRequest(uri));

    if (payload != null) {
      request.add(utf8.encode(json.encode(payload)));
    }
    HttpClientResponse response = await request.close();
    await cookieJar.saveFromResponse(uri, response.cookies);
    String responseBody = await response.transform(utf8.decoder).join();
    print('PUT 请求返回: $responseBody');
    Map<String, dynamic> data = json.decode(responseBody);
    return data;
  }

  static Future<Map<String, dynamic>> DELETE(String path,
      {Map<String, dynamic>? params, Map<String, dynamic>? payload}) async {
    Uri uri = Uri(
        scheme: _scheme,
        host: _host,
        port: _port,
        path: path,
        queryParameters: params);
    HttpClientRequest request = await httpClient.deleteUrl(uri);
    request.cookies.addAll(await cookieJar.loadForRequest(uri));

    if (payload != null) {
      request.add(utf8.encode(json.encode(payload)));
    }
    HttpClientResponse response = await request.close();
    await cookieJar.saveFromResponse(uri, response.cookies);
    String responseBody = await response.transform(utf8.decoder).join();
    print('DELETE 请求返回: $responseBody');
    Map<String, dynamic> data = json.decode(responseBody);
    return data;
  }

  static Future<Map<String, dynamic>> POST(String path,
      {Map<String, dynamic>? params, Map<String, dynamic>? payload}) async {
    Uri uri = Uri(
        scheme: _scheme,
        host: _host,
        port: _port,
        path: path,
        queryParameters: params);
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.cookies.addAll(await cookieJar.loadForRequest(uri));
    if (payload != null) {
      print('添加body:${json.encode(payload)}');
      request.add(utf8.encode(json.encode(payload)));
    }
    HttpClientResponse response = await request.close();
    await cookieJar.saveFromResponse(uri, response.cookies);
    String responseBody = await response.transform(utf8.decoder).join();
    print('POST 请求返回: $responseBody');
    Map<String, dynamic> data = json.decode(responseBody);
    return data;
  }

  static Future<Map<String, dynamic>> Upload(PlatformFile file, String dir, String fileName) async {
    Uri uri = Uri(scheme: _scheme, host: _host, port: _port,path: '/api/v3/file/upload');
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.cookies.addAll(await cookieJar.loadForRequest(uri));
    request.headers
        .add(HttpHeaders.contentTypeHeader, "application/octet-stream");
    request.headers.add('x-filename', Uri.encodeComponent(fileName));
    request.headers.add('x-path', Uri.encodeComponent(dir));
    var size = file.size;
    request.headers.add(HttpHeaders.contentLengthHeader, size);
    int byteCount = 0;
    Stream<List<int>> stream = await file.readStream!.transform(
          new StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              byteCount += data.length;
              // 计算上传速度
              print('上传: $byteCount/$size'); // 这里可以更新上传文件的进度
              sink.add(data);
            },
            handleError: (error, stack, sink) {},
            handleDone: (sink) {
              sink.close();
            },
          ),
        );
    await request.addStream(stream);
    // 文件发送完成
    HttpClientResponse response = await request.close();
    await cookieJar.saveFromResponse(uri, response.cookies);
    // 获取返回数据
    String responseBody = await response.transform(utf8.decoder).join();
    Map<String, dynamic> data = json.decode(responseBody);
    return data;
  }
}
