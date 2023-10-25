import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/task-overall-view/api/task-overall-api.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TaskOverallViewController extends BaseController {
  TaskOverallViewController({required this.eventID, required this.eventName});

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  String eventID = '';
  String eventName = '';

  RxList<TaskModel> listTask = <TaskModel>[].obs;
  RxBool isLoading = false.obs;

  RxList<String> filterList = <String>[
    "Không chọn",
    "Ngày tạo (Tăng dần)",
    "Ngày tạo (Giảm dần)",
    "Hạn hoàn thành (Tăng dần)",
    "Hạn hoàn thành (Giảm dần)",
    "Mức độ ưu tiên (Tăng dần)",
    "Mức độ ưu tiên (Giảm dần)",
  ].obs;

  Future<void> refreshPage() async {
    listTask.clear();
    String jwt = GetStorage().read('JWT');
    print('1: ${isLoading.value}');
    isLoading.value = true;
    await getListTask();
    isLoading.value = false;
  }

  Future<void> getTaskDetail(String taskID) async {
    Get.toNamed(Routes.TASK_DETAIL_VIEW, arguments: {"taskID": taskID});
  }

  Future<void> getListTask() async {
    String jwt = GetStorage().read('JWT');
    print('JWT 123: $jwt');
    isLoading.value = true;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    // listTask.value =
    //     await TaskOverallApi.getTask(jwt, eventID, decodedToken['id']);
    listTask.clear();
    List<TaskModel> list = [];
    list = await TaskOverallApi.getTask(jwt, eventID);
    if (list.isNotEmpty) {
      for (var item in list) {
        if (item.assignTasks!.isNotEmpty) {
          if (item.parent == null &&
              item.status != Status.CANCEL &&
              item.assignTasks![0].user!.id == decodedToken['id']) {
            listTask.add(item);
          }
        }
      }

      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    }
    isLoading.value = false;

    print('co bao nhieu task cha ${listTask.length}');
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getListTask();
    // listEventModel.value = [
    //   TaskModel(
    //       title:
    //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
    //       image:
    //           'https://www.shutterstock.com/image-vector/events-colorful-typography-banner-260nw-1356206768.jpg',
    //       startTime: DateTime.now(),
    //       endTime: DateTime.now(),
    //       isParent: true,
    //       status: 'INPROGRESS',
    //       totalTask: 3,
    //       index: 0),
    //   TaskModel(
    //       title: 'Lorem Ipsum is simply dummy text',
    //       image: '',
    //       startTime: DateTime.now(),
    //       status: 'DONE',
    //       endTime: DateTime.now(),
    //       isParent: false,
    //       totalTask: 3,
    //       index: 1),
    //   TaskModel(
    //       title: 'Lorem Ipsum is simply dummy text',
    //       image: '',
    //       startTime: null,
    //       status: 'INPROGRESS',
    //       endTime: null,
    //       isParent: false,
    //       totalTask: 3,
    //       index: 2),
    //   TaskModel(
    //       title: 'Lorem Ipsum is simply dummy text',
    //       image: '',
    //       status: 'CANCEL',
    //       startTime: DateTime.now(),
    //       endTime: DateTime.now(),
    //       isParent: false,
    //       totalTask: 3,
    //       index: 3),
    // ];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
