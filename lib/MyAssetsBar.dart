import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ConstantWidget.dart';
import 'dart:ui' as ui;

import 'Constants.dart';

const double _kHeight = 25;

enum OrderType { Ascending, Descending, None }

class MyAsset {
  double? size;
  Color? color;
  String? title;

  MyAsset({this.size, this.color, this.title});
}

class MyAssetsBar extends StatelessWidget {
  final int? pointer;
  final double? width;
  final double? height;
  final double? radius;
  final List<MyAsset>? assets;
  final double? assetsLimit;
  final OrderType? order;
  final Color? background;

  MyAssetsBar(
      {this.width,
      this.height = _kHeight,
      this.radius,
      this.assets,
      this.assetsLimit,
      this.order,
      this.pointer,
      this.background})
      : assert(width != null);

  double _getValuesSum() {
    double sum = 0;
    assets!.forEach((single) => sum += single.size!);
    return sum;
  }

  void orderMyAssetsList() {
    switch (order) {
      case OrderType.Ascending:
        {
          //From the smallest to the largest
          assets!.sort((a, b) {
            return a.size!.compareTo(b.size!);
          });
          break;
        }
      case OrderType.Descending:
        {
          //From largest to smallest
          assets!.sort((a, b) {
            return b.size!.compareTo(a.size!);
          });
          break;
        }
      case OrderType.None:
      default:
        {
          break;
        }
    }
  }

  Widget _createSingle(MyAsset singleAsset) {
    return SizedBox(
      width: (singleAsset.size! * width!) / (assetsLimit ?? _getValuesSum()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(singleAsset.title!,
              style: TextStyle(
                  fontSize: ConstantWidget.getPercentSize(height!, 40),
                  color: Colors.white,
                  fontFamily: Constants.fontsFamily,
                  fontWeight: FontWeight.w700)),
          Container(
            color: singleAsset.color,
            height: ConstantWidget.getPercentSize(height!, 35),
          )
        ],
      ),
    );
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    if (assetsLimit != null && assetsLimit! < _getValuesSum()) {
      print("assetsSum < _getValuesSum() - Check your values!");
      return Container();
    }
    orderMyAssetsList();

    final double rad = radius ?? (height! / 2);
    int pointerWidth = pointer! * 2;
    double leftPosition;
    if (pointerWidth >= 100) {
      leftPosition = (width! - 20);
    } else {
      leftPosition = (width! * (pointerWidth / 100));
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(rad)),
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.transparent,
        ),
        width: width,
        height: height! + ConstantWidget.getScreenPercentSize(context, 2),
        child: Stack(
          children: [
            Row(
                children: assets!
                    .map((singleAsset) => _createSingle(singleAsset))
                    .toList()),
            new Positioned(
              top: height! + 7,
              left: leftPosition,
              child: Icon(
                Icons.arrow_drop_up,
                size: 30,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
