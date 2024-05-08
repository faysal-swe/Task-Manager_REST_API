import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/ui/utils/asset_utils.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          SizedBox(
              width:double.infinity,
              height:double.infinity,
              child:SvgPicture.asset(
                  AssetUtils.backgroundSvg,
                  fit:BoxFit.cover
              )
          ),
          child
        ]
    );
  }
}
