import 'package:flutter/material.dart';
import 'package:glo_trans/model/drift/translate_res_model.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:native_context_menu/native_context_menu.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late RefreshController _refreshController;
  late AppDataViewModel appDataViewModel;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    appDataViewModel = context.read<AppDataViewModel>();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    print("onRefresh");
    // await Future.delayed(const Duration(seconds: 1));
    // // _refreshController.loadFailed();
    // // _refreshController.loadNoData();
    // // _refreshController.refreshFailed();
    // _refreshController.refreshCompleted();
    await appDataViewModel.getTranslateResFirstPage();
    _refreshController.refreshCompleted();
    setState(() {});
    print("onRefresh completed");
  }

  Future<void> _onLoading() async {
    print("onLoading");
    // 没啥用，加点效果哈哈哈哈哈哈哈哈😂
    await Future.delayed(const Duration(milliseconds: 500));
    // _refreshController.loadComplete();
    // print("onLoading completed");
    appDataViewModel
        .getTranslateResByPageId(appDataViewModel.historyTotalPageCount);
    _refreshController.loadComplete();
    setState(() {});
    print("onLoading completed");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Selector<AppDataViewModel, List<TranslateResModel>>(
            selector: (_, vm) => vm.translateHistory,
            builder: (context, translateResModelList, child) {
              if (translateResModelList.isEmpty) {
                return const Center(child: Text("暂无翻译历史"));
              }
              return SmartRefresher(
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    TranslateResModel translateResModel =
                        translateResModelList[index];
                    return ContextMenuRegion(
                      onItemSelected: (item) async {
                        if (item.action == 0) {
                          print("详情查看");
                          appDataViewModel.currentTable =
                              translateResModel.data;
                          appDataViewModel.switchPage(1);
                        } else if (item.action == 1) {
                          print("删除记录");
                          int success = await appDataViewModel
                              .deleteTranslateRes(translateResModel.id!);
                          if (success == 1) {
                            print("删除成功");
                            showToast("删除成功");
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            _refreshController.requestRefresh();
                          } else {
                            print("删除失败");
                            showToast("删除失败");
                          }
                        }
                      },
                      menuItems: [
                        MenuItem(
                          title: '详情查看',
                          action: 0,
                          onSelected: () {
                            print("详情查看");
                            appDataViewModel.currentTable =
                                translateResModel.data;
                            appDataViewModel.switchPage(1);
                          },
                        ),
                        MenuItem(title: '删除记录', action: 1),
                        // MenuItem(
                        //   title: 'Third item with submenu',
                        //   items: [
                        //     MenuItem(title: 'First subitem'),
                        //     MenuItem(title: 'Second subitem'),
                        //   ],
                        // ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 104, 146, 179),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 100,
                          height: 100,
                          // 这里显示翻译时间，key，value
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateResModel.time.substring(0, 19),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "语言(${translateResModel.data[0].length - 2})：${translateResModelList[index].data[0].sublist(2).map((e) => e.split("_")[0]).join(",")}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "文本(${translateResModel.data.length - 1})：${translateResModelList[index].data.map((e) => e[1]).toList().sublist(1).join(",")}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 1);
                  },
                  itemCount: translateResModelList.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
