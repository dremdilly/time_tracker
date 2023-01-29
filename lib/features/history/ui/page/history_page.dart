import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracker/constants/colors.dart';
import 'package:time_tracker/constants/text_style_values.dart';
import 'package:time_tracker/features/app/app_bloc/app_bloc.dart';
import 'package:time_tracker/localization/extensions.dart';
import 'package:time_tracker/services/analytics_service.dart';
import 'package:time_tracker/services/locator.dart';
import 'package:time_tracker/translations_key/locale_keys.g.dart';

import '../../bloc/history_bloc.dart';
import '../widget/history_task_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController _scrollController = ScrollController();
  late AppBloc appBloc;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  late HistoryBloc historyBloc;

  @override
  void initState() {
    historyBloc = HistoryBloc();
    appBloc = BlocProvider.of<AppBloc>(context);
    historyBloc.add(GetHistoryTasksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget,
      backgroundColor: AppColors.white,
      body: BlocConsumer(
        bloc: historyBloc,
        listener: (context, state) {},
        builder: (context, state)  {
          List<Widget> children = [];
          if (state is GetHistoryTasksState) {
            for (var item in state.completedTasks) {
              children
                  .add(SizedBox(height: 10.h,));
              children
                  .add(HistoryTaskItem(task: item));
              children
                  .add(SizedBox(height: 10.h,));
            }
          }
          return buildBody(children);
        },
      ),
    );
  }

  Widget buildBody(List<Widget> tasks) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Column(children: [
        SizedBox(height: 25.h),
        buildSectionHeader(),
        Column(
          children: tasks,
        )
      ]),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        LocaleKeys.history.tr(),
        style: AppTextStyles.h2_white,
      ),
      backgroundColor: AppColors.lightRed,
      elevation: 0,
    );
  }

  Widget buildSectionHeader() {
    return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [buildSectionName(), buildSectionMenu()],
        ));
  }

  Widget buildSectionName() {
    return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Text(LocaleKeys.completedTasks.tr(),
            style: AppTextStyles.h3_white
                .copyWith(color: AppColors.black, fontSize: 25.sp)));
  }

  Widget buildSectionMenu() {
    return FloatingActionButton.extended(
      label: Text(
        LocaleKeys.exportToCsv.tr(),
        style: AppTextStyles.h3_white
      ),
      backgroundColor: AppColors.lightRed,
      onPressed: () {
         historyBloc.add(ExportToCsvEvent());
      });
  }
}
