import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_yoga_workout_4_all_new/custom_workout/select_workout.dart';
import 'package:flutter_yoga_workout_4_all_new/custom_workout/workout_custom.dart';



// import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../models/model_get_custom_plan_exercise.dart';

import 'package:get/get.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../HomeWidget.dart';
import '../Widgets.dart';
import '../controller/home_controller.dart';
import '../dialog/bottom_dialog.dart';
import '../models/ModelDummySend.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../onlineData/dummy_data.dart';

class SelectedList extends StatefulWidget {
  final ModelDummySend _modelCustomList;

  SelectedList(this._modelCustomList);

  @override
  State<SelectedList> createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList>
    with TickerProviderStateMixin {
  Future<bool> _requestPop() {
    Get.to(HomeWidget());

    return new Future.value(false);
  }

  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;
  double getCal = 0;
  int getTime = 0;

  @override
  void initState() {
    DummyData.removeAllData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();
    // myBanner.load();
    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });
  }

  // final BannerAd myBanner = BannerAd(
  //   adUnitId: Platform.isAndroid
  //       ? 'ca-app-pub-3940256099942544/6300978111'
  //       : "ca-app-pub-3940256099942544/2934735716",
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(
  //     // Called when an ad is successfully received.
  //     onAdLoaded: (Ad ad) => print('Ad loaded.'),
  //     // Called when an ad request failed.
  //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //       // Dispose the ad here to free resources.
  //       ad.dispose();
  //       print('Ad failed to load: $error');
  //     },
  //     // Called when an ad opens an overlay that covers the screen.
  //     onAdOpened: (Ad ad) => print('Ad opened.'),
  //     // Called when an ad removes an overlay that covers the screen.
  //     onAdClosed: (Ad ad) => print('Ad closed.'),
  //     // Called when an impression occurs on the ad.
  //     onAdImpression: (Ad ad) => print('Ad impression.'),
  //   ),
  // );

  @override
  void dispose() {
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    try {
      if (animationController != null) {
        animationController!.dispose();
      }
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => WillPopScope(
        onWillPop: () {
          controller.onChange(2.obs);
          return _requestPop();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                ConstantWidget.getVerSpace(20.h),
                buildAppBar(controller),
                ConstantWidget.getVerSpace(20.h),
                buildSelectedList(),
                buildDoneButton(context),
                ConstantWidget.getVerSpace(20.h),
                // Container(
                //   alignment: Alignment.center,
                //   child: AdWidget(ad: myBanner),
                //   width: myBanner.size.width.toDouble(),
                //   height: myBanner.size.height.toDouble(),
                // ),
                ConstantWidget.getVerSpace(10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomDialog(Exercisedetail exercisedetail) {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: getDecorationWithSide(
              radius: 22.h,
              bgColor: Colors.white,
              isTopLeft: true,
              isTopRight: true),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            primary: false,
            children: [
              ConstantWidget.getVerSpace(44.h),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ConstantWidget.getCustomTextWidget(
                        'Info',
                        Colors.black,
                        22.sp,
                        FontWeight.w700,
                        TextAlign.start,
                        1),
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child:
                          getSvgImage("close.svg", height: 24.h, width: 24.h))
                ],
              ),
              ConstantWidget.getVerSpace(23.h),
              Image.network(
                "${ConstantUrl.uploadUrl}${exercisedetail.image}",
                height: 332.h,
                width: 233.h,
                fit: BoxFit.fill,
              ),
              ConstantWidget.getVerSpace(16.h),
              ConstantWidget.getCustomText("How to perform?", Colors.black, 1,
                  TextAlign.start, FontWeight.w700, 20.sp),
              ConstantWidget.getVerSpace(13.h),
              HtmlWidget(
                Constants.decode(exercisedetail.description),
                textStyle: TextStyle(
                    color: "#525252".toColor(),
                    fontSize: 17.sp,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.w500,
                    height: 1.41.h),
              ),
              ConstantWidget.getVerSpace(34.h),
            ],
          ),
        );
      },
    );
  }

  List<Exercisedetail>? list;
  List<Customplanexercise>? customPlanExerciseList;
  ModelGetCustomPlanExercise? modelGetCustomPlanExercise;

  Expanded buildSelectedList() {
    return Expanded(
      flex: 1,
      child: FutureBuilder<ModelGetCustomPlanExercise?>(
        future: getCustomPlanExercise(context),
        builder: (context, snapshot) {
          getCal = 0;
          getTime = 0;
          if (snapshot.hasData && snapshot.data != null) {
            modelGetCustomPlanExercise = snapshot.data;

            print(
                "refresh===true====${modelGetCustomPlanExercise!.data.idList.length}");

            if (modelGetCustomPlanExercise!.data.success == 1) {
              customPlanExerciseList =
                  modelGetCustomPlanExercise?.data.customplanexercise;

              customPlanExerciseList!.forEach((price) {
                getTime = getTime + int.parse(price.exerciseTime!);
              });

              getCal = Constants.calDefaultCalculation * getTime;
              return ListView.builder(
                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                primary: true,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: customPlanExerciseList?.length,
                itemBuilder: (context, index) {
                  Customplanexercise customplanexercise =
                      customPlanExerciseList![index];

                  // list = customPlanExerciseList[index].exercisedetail.;

                  Exercisedetail exercisedetail =
                      customplanexercise.exercisedetail;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Curves.fastOutSlowIn,
                    ),
                  );
                  animationController!.forward();
                  return GestureDetector(
                    onTap: () {
                      showBottomDialog(exercisedetail);
                    },
                    child: AnimatedBuilder(
                      animation: animationController!,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 50 * (1.0 - animation.value), 0.0),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              padding: EdgeInsets.only(
                                  left: 12.h,
                                  top: 12.h,
                                  bottom: 12.h,
                                  right: 20.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: containerShadow,
                                        blurRadius: 32,
                                        offset: Offset(-2, 5))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 78.h,
                                          width: 78.h,
                                          decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(12.h)),
                                          child: Image.network(
                                              ConstantUrl.uploadUrl +
                                                  exercisedetail.image),
                                        ),
                                        getHorSpace(12.h),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstantWidget.getCustomText(
                                                  exercisedetail.exerciseName,
                                                  textColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w700,
                                                  17.sp),
                                              ConstantWidget.getVerSpace(12.h),
                                              Row(
                                                children: [
                                                  getSvgImage("Clock.svg",
                                                      width: 15.h,
                                                      height: 15.h),
                                                  getHorSpace(7.h),
                                                  ConstantWidget.getCustomText(
                                                      "${customplanexercise.exerciseTime}s",
                                                      "#525252".toColor(),
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      14.sp)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    position: PopupMenuPosition.under,
                                    offset: Offset(20, 10),
                                    child: Container(
                                      child: getSvgImage("more.svg",
                                          height: 24.h, width: 24.h),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h)),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          height: 50.h,
                                          padding: EdgeInsets.only(
                                              right: 60.h, left: 20.h),
                                          value: "edit",
                                          child: ConstantWidget.getCustomText(
                                              "Edit",
                                              textColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              17.sp),
                                        ),
                                        PopupMenuItem(
                                          padding: EdgeInsets.only(
                                              right: 60.h, left: 20.h),
                                          value: "delete",
                                          child: ConstantWidget.getCustomText(
                                              "Delete",
                                              textColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              17.sp),
                                          height: 50.h,
                                        ),
                                      ];
                                    },
                                    onSelected: (value) async {
                                      if (value == "edit") {
                                        showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    22.h))),
                                                builder: (context) {
                                                  return BottomDialog(
                                                      customPlanExerciseList![
                                                          index]);
                                                },
                                                context: context)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else if (value == "delete") {
                                        ConstantUrl.deleteExercise(context, () {
                                          setState(() {});
                                        },
                                            customplanexercise
                                                .customPlanExerciseId,
                                            customplanexercise
                                                .exercisedetail.exerciseId);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return getNoData(context);
            }
          } else {
            return getProgressDialog();
          }
        },
      ),
    );
  }

  Widget buildAppBar(HomeController controller) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                  child:
                      getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
                  onTap: () {

                    controller.onChange(2.obs);
                    _requestPop();
                  }),
              getHorSpace(12.sp),
              getCustomText("Custom Workout", textColor, 1, TextAlign.start,
                  FontWeight.w700, 22.sp)
            ],
          ),
          GestureDetector(
              onTap: () {
                print(
                    "refresh===true====${modelGetCustomPlanExercise!.data.idList.length}");

                if (modelGetCustomPlanExercise != null) {
                  Get.to(() =>
                      SelectWorkout(modelGetCustomPlanExercise!.data.idList));
                }
              },
              child: getSvgImage("add.svg",
                  height: 30.h, width: 30.h, color: textColor))
        ],
      ),
    );
  }

  Widget buildDoneButton(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getButton(context, accentColor, "Start", Colors.white, () {

        if(customPlanExerciseList!=null && customPlanExerciseList!.length > 0){
          Get.to(() => WorkoutCustom(
              customPlanExerciseList!, widget._modelCustomList, getCal, getTime));
        }

      }, 20.sp,
          weight: FontWeight.w700,
          buttonHeight: 60.h,
          borderRadius: BorderRadius.circular(22.h)),
    );
  }
}
