/*class AttachmentViewResponse {
  String? attachmentId;
  List<String>? images;

  AttachmentViewResponse({this.attachmentId, this.images});

  AttachmentViewResponse.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachment_id'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachment_id'] = attachmentId;
    data['images'] = images;
    return data;
  }
}*/

class AttachmentResponse {
  List<StringUrl>? attachments;

  AttachmentResponse({this.attachments});

  AttachmentResponse.fromJson(Map<String, dynamic> json) {
    if (json['attachments'] != null) {
      attachments = <StringUrl>[];
      json['attachments'].forEach((v) {
        attachments!.add(StringUrl.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StringUrl {
  int? attachmentId;
  String? imageUrl;

  StringUrl({this.attachmentId, this.imageUrl});

  StringUrl.fromJson(Map<String, dynamic> json) {
    attachmentId = json['ATTACHMENT_ID'];
    imageUrl = json['IMAGES'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ATTACHMENT_ID'] = attachmentId;
    data['IMAGES'] = imageUrl;
    return data;
  }
}
