import '../model/img_api_response_model.dart';

class HomeState {
  ImgApiResponseModel? imgApiResponseModel;

  HomeState({
    this.imgApiResponseModel,
  });

  HomeState copyWith({
    ImgApiResponseModel? imgApiResponseModel,
  }) {
    return HomeState(
      imgApiResponseModel: imgApiResponseModel ?? this.imgApiResponseModel,
    );
  }
}
