import 'package:cloudreve/app/api/file_item.dart';
import 'package:flutter/material.dart';

enum FileType {
  dir,
  image,
  word,
  zip,
  apk,
  music,
  file,
  video
}

var imageRex = RegExp(r".*\.(jpg|gif|bmp|png|jpeg)");
var wordRegex = RegExp(r".*\.(doc|docx|txt)");
var zipRegex = RegExp(r".*\.(zip|rar|7z)");
var apkRegex = RegExp(r".*\.(apk)");
var mp3Regex = RegExp(r".*\.(mp3)");
var mp4Regex = RegExp(r".*\.(mp4)");

FileType getFileType(FileData file) {
  if (file.type == 'dir') {
    return FileType.dir;
  } else if (imageRex.hasMatch(file.name)) {
    return FileType.image;
  } else if (zipRegex.hasMatch(file.name)) {
    return FileType.zip;
  } else if (wordRegex.hasMatch(file.name)) {
    return FileType.word;
  } else if (apkRegex.hasMatch(file.name)) {
    return FileType.apk;
  } else if (mp3Regex.hasMatch(file.name)) {
    return FileType.music;
  } else if (mp4Regex.hasMatch(file.name)) {
    return FileType.video;
  }
  return FileType.file;
}

/// 获取svg图片
String getFileSvg(FileType type) {
  String img = 'assets/images/ic_file_type_file.svg';
  switch (type) {
    case FileType.dir:
      img = 'assets/images/ic_folder.svg';
      break;
    case FileType.file:
      break;
    case FileType.image:
      img = 'assets/images/ic_file_type_image.svg';
      break;
    case FileType.zip:
      break;
    case FileType.word:
      img = 'assets/images/ic_file_type_doc.svg';
      break;
    case FileType.apk:
      break;
    case FileType.music:
      img = 'assets/images/ic_file_type_video.svg';
      break;
    case FileType.video:
      img = 'assets/images/ic_file_type_video.svg';
      break;
  }
  return img;
}

///构建文件列表浏览
Icon getFileIcon(FileType type) {
  Icon icon = Icon(Icons.file_present,color: Colors.white);

  switch (type) {
    case FileType.dir:
      icon = Icon(Icons.folder_outlined, color: Colors.white);
      break;
    case FileType.file:
      break;
    case FileType.image:
      icon = Icon(Icons.image_outlined, color: Colors.white);
      break;
    case FileType.zip:
      icon = Icon(Icons.archive, color: Colors.white);
      break;
    case FileType.word:
      icon = Icon(Icons.book, color: Colors.white);
      break;
    case FileType.apk:
      icon = Icon(Icons.android, color: Colors.white,);
      break;
    case FileType.music:
      icon = Icon(Icons.music_note,color: Colors.white,);
      break;
  }
  return icon;
}