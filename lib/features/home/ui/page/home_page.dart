import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracker/constants/colors.dart';
import 'package:time_tracker/constants/constant_text.dart';
import 'package:time_tracker/constants/text_style_values.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/app/app_bloc/app_bloc.dart';
import 'package:time_tracker/features/home/bloc/home_bloc.dart';
import 'package:time_tracker/features/home/ui/widget/section_item.dart';
import 'package:time_tracker/localization/extensions.dart';
import 'package:time_tracker/models/SectionModel.dart';
import 'package:time_tracker/routes.dart';
import 'package:time_tracker/services/analytics_service.dart';
import 'package:time_tracker/services/locator.dart';
import 'package:time_tracker/services/shared_preference.dart';
import 'package:time_tracker/translations_key/locale_keys.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;
  final PageController _pageController = PageController(viewportFraction: 0.88);
  late AppBloc appBloc;
  late HomeBloc homeBloc;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  late List<Sections> sectionsList;
  bool isEmptyTextField = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    homeBloc = HomeBloc();
    appBloc = BlocProvider.of<AppBloc>(context);
    homeBloc.add(GetSectionsEvent());
    isDarkMode = sharedPreference.darkMode!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  (!sharedPreference.darkMode!) ? AppColors.white : AppColors.dark,
      body: BlocConsumer(
        bloc: homeBloc,
        listener: (context, state) {},
        builder: (context, state) {
          List<Widget> children = [];
          if (state is GetSectionsState) {
            for (var item in state.sections) {
              children.add(
                  SectionItem(pageController: _pageController, section: item));
            }
            children.add(addSection());
          }
          return buildBody(children);
        },
      ),
    );
  }

  Widget buildBody(List<Widget> sections) {
    return Column(
      children: [
        buildAppBar(),
        Expanded(
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              onSwipeEvent(index);
            },
            children: sections,
          ),
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text(
        ConstantText.appName,
        style: AppTextStyles.h2_white,
      ),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.history), onPressed: () {
          Navigator.pushNamed(context, Routes.history);
        }),
        IconButton(icon: const Icon(Icons.settings), onPressed: () {
          Navigator.pushNamed(context, Routes.setting);
        })
      ],
      backgroundColor: sharedPreference.darkMode! ? AppColors.dark : AppColors.lightRed,
      elevation: 0,
    );
  }

  Widget addSection() {
    return Column(
      children: [
        SizedBox(
          height: 25.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: SizedBox(
            width: double.infinity,
            child: FloatingActionButton.extended(
                backgroundColor: AppColors.lightGray,
                label: Text(
                  LocaleKeys.addSections.tr(),
                  style: AppTextStyles.regular_black,
                ),
                icon: const ImageIcon(
                  AssetImage('assets/icons/ic_add.png'),
                  size: 24.0,
                  color: AppColors.black,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                onPressed: () {
                  showModalBottomSectionInputSheet();
                }),
          ),
        ),
      ],
    );
  }

  void showModalBottomSectionInputSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: AppTextStyles.regular_black
                      .copyWith(fontWeight: FontWeight.bold),
                  decoration: getSectionInputDecoration(),
                  onSubmitted: (value) => _addNewSection(value),
                  onChanged: (value) {
                    value.isNotEmpty
                        ? setState(() => isEmptyTextField = false)
                        : setState(() => isEmptyTextField = true);
                  },
                ));
          });
        });
  }

  void _addNewSection(String value) {
    sectionsDao.insertSection(SectionModel(title: value));
    setState(() => {homeBloc.add(GetSectionsEvent())});
    Navigator.pop(context);
  }

  InputDecoration getSectionInputDecoration() {
    return InputDecoration(
        contentPadding: EdgeInsetsDirectional.only(start: 10.w, top: 20.h),
        hintText: LocaleKeys.sectionName.tr(),
        hintStyle: AppTextStyles.regular_black
            .copyWith(fontWeight: FontWeight.bold, color: AppColors.lightGray),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(width: 0.0, color: Colors.white)),
        suffixIcon: IconButton(
          icon: ImageIcon(
            const AssetImage('assets/icons/ic_arrow_up_circle.png'),
            size: 30.r,
          ),
          color: !isEmptyTextField ? AppColors.lightRed : AppColors.gray,
          onPressed: !isEmptyTextField
              ? () {
                  _addNewSection(_controller.value.text);
                }
              : null,
        ));
  }

  void onSwipeEvent(int index) {}
}
