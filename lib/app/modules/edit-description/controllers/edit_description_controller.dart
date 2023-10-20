import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/controllers/task_detail_view_controller.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDescriptionController extends BaseController {
  EditDescriptionController(
      {required this.quillController, required this.taskModel});
  Rx<TaskModel> taskModel = TaskModel().obs;
  RxBool isLoading = false.obs;
  String jwt = '';
  Rx<QuillController> quillController = QuillController.basic().obs;

  Rx<QuillController> quillServerController = QuillController.basic().obs;
  RxBool errorUpdateTask = false.obs;
  RxString errorUpdateTaskText = ''.obs;

  FocusNode focusNodeDetail = FocusNode();

  QuillController coppyController(QuillController controller) {
    QuillController abc = QuillController(
      document: Document.fromDelta(controller.document.toDelta()),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return abc;
  }

  Future<void> saveDescription() async {
    // quillServerController.value = coppyController(quillController.value);
    // Get.find<TaskDetailViewController>().descriptionString.value =
    //     quillController.value.document.toDelta().toString();
    // print(quillController.value.document.toDelta().toJson().toString());

    // Get.find<TaskDetailViewController>().descriptionString.value =
    //     quillController.value.document.toDelta().toJson().toString();

    // Get.back();

    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (GetStorage().read('JWT') != null) {
        jwt = GetStorage().read('JWT');
      } else {
        jwt = prefs.getString('JWT')!;
      }
      ResponseApi responseApi = await TaskDetailApi.updateDescriptionTask(
          jwt,
          taskModel.value.id!,
          taskModel.value.eventId!,
          '${jsonEncode(quillController.value.document.toDelta())}');
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        Get.find<TaskDetailViewController>().getTaskDetail();
        errorUpdateTask.value = false;
        Get.back();
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Có lỗi xảy ra';
      print(e);
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    // quillServerController.value = QuillController(
    //   document: Document.fromJson(myJSON),
    //   selection: const TextSelection.collapsed(offset: 0),
    // );
    // print('asd123 ${quillController.value}');
    // quillController.value = QuillController(
    //   document: Document.fromJson(myJSON),
    //   selection: const TextSelection.collapsed(offset: 0),
    // );
    super.onInit();
  }

  // discardDescription() {
  //   quillController.value = coppyController(quillServerController.value);
  //   print(
  //       'quillController.value 2 ${quillServerController.value.document.toDelta()}');
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}