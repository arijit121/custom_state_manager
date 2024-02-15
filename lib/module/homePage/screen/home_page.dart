import 'package:custom_state_manager/extension/AppLog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_obx/flutter_obx.dart';

// import '../../extension/obx.dart';
// import '../../extension/obx_widget.dart';
import '../../../service/PopUpItems.dart';
import '../../../service/ScreenProperty.dart';
import '../model/img_api_response_model.dart';
import '../repo/homerepo.dart';
import '../state/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Obx<HomeState> homeController = Obx<HomeState>(value: HomeState());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PopUpItems().showLoaderDialog(ScreenProperty.getCurrentContext());
      try {
        ImgApiResponseModel? imgApiResponseModel = await HomeRepo().getData();
        homeController.emit(homeController.obs
            .copyWith(imgApiResponseModel: imgApiResponseModel));
      } catch (e, s) {
        AppLog.e(e, stackTrace: s);
      }
      Navigator.pop(ScreenProperty.getCurrentContext());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ObxProvider<HomeState>(
          obxController: homeController,
          builder: (BuildContext context, HomeState value, Widget? child) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return PhysicalModel(
                      color: Colors.white,
                      elevation: 18,
                      shadowColor: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        tileColor: Colors.white,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            value.imgApiResponseModel?.dataList
                                    ?.elementAt(index)
                                    .url ??
                                "",
                            height: 40,
                            errorBuilder: (_, __, ___) {
                              return const Icon(
                                Icons.broken_image,
                                size: 20,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          value.imgApiResponseModel?.dataList
                                  ?.elementAt(index)
                                  .title ??
                              "",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                        height: 5,
                      ),
                  itemCount: value.imgApiResponseModel?.dataList?.length ?? 0),
            );
          }),
    );
  }
}
