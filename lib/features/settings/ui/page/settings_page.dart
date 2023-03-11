import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracker/constants/colors.dart';
import 'package:time_tracker/constants/text_style_values.dart';
import 'package:time_tracker/features/app/ui/page/app.dart';
import 'package:time_tracker/services/shared_preference.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkMode;

  @override
  void initState() {
    isDarkMode = sharedPreference.darkMode!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget,
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.lightSilver ,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        buildChangeThemeCard(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Settings',
        style: AppTextStyles.h2_white,
      ),
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.lightRed,
      elevation: 0,
    );
  }

  Widget buildChangeThemeCard() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Container(
          decoration: getBoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Dark mode',
                  style: isDarkMode
                      ? AppTextStyles.regular_white
                      : AppTextStyles.regular_black),
              Switch(
                  inactiveTrackColor: AppColors.lightGray,
                  activeColor: AppColors.lightRed,
                  value: isDarkMode,
                  onChanged: (value) {
                    sharedPreference.saveDarkMode(value);
                    setState(() {
                      isDarkMode = value;
                    });
                  }),
            ],
          )),
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: isDarkMode ? AppColors.darkGrey : AppColors.white,
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
    );
  }
}
