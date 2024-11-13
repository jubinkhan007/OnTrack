class AttachmentViewResponse {
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
}
