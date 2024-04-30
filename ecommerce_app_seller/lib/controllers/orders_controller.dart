import 'package:ecommerce_app_seller/controllers/home_controller.dart';
import 'package:ecommerce_app_seller/services/firebase_notifications.dart';
import 'package:ecommerce_app_seller/views/home_screen/home.dart';
import 'package:get/get.dart';

import '../const/firebase_consts.dart';
import '../views/orders_screen/orders_screen.dart';
import '../widgets/utils.dart';

class OrdersController extends GetxController {
  RxBool isLoading = false.obs;

  confirmOrder(id, index, context, title, token) async {
    isLoading(true);

    final doc = await firestore.collection('orders').doc(id).get();
    final products = doc["orders"];
    products[index]['order_confirmed'] = true;
    await firestore.collection('orders').doc(id).update({"orders": products});
    Get.find<HomeController>().navIndex.value = 1;
    Get.offAll(() => const Home());
    isLoading(false);
    Utils.showToast("order confirmed");
    sendNotif("Order Update", 'your ordered $title is confirmed', token);

  }

  onDeliveryOrder(id, index, context, title, token) async {
    isLoading(true);

    final doc = await firestore.collection('orders').doc(id).get();
    final products = doc["orders"];
    products[index]['order_on_delivery'] = true;
    await firestore.collection('orders').doc(id).update({"orders": products});
    Get.find<HomeController>().navIndex.value = 1;
    Get.offAll(() => const Home());
    isLoading(false);
    Utils.showToast("order is on delivery");
    sendNotif("Order Update", 'your ordered $title is on delivery', token);

  }

  deliveredOrder(id, index, context, title, token) async {
    isLoading(true);

    final doc = await firestore.collection('orders').doc(id).get();
    final products = doc["orders"];
    products[index]['order_delivered'] = true;
    await firestore.collection('orders').doc(id).update({"orders": products});
    Get.find<HomeController>().navIndex.value = 1;
    Get.offAll(() => const Home());
    isLoading(false);
    Utils.showToast("order delivered");
    sendNotif("Order Update", 'your ordered $title is delivered', token);
  }
}
