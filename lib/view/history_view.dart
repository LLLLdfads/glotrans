import 'package:flutter/material.dart';
import 'package:glo_trans/model/translate_result_model.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Selector<AppDataViewModel, TranslateResultModelList?>(
            selector: (_, vm) => vm.translateResultModelList,
            builder: (context, translateResultModelList, child) {
              if (translateResultModelList == null) {
                return const Center(child: Text("暂无翻译历史"));
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 104, 146, 179),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 100,
                          height: 100,
                          // 这里显示翻译时间，key，value
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateResultModelList
                                      .translateResultList[index].time
                                      .substring(0, 19),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  translateResultModelList
                                      .translateResultList[index].rows
                                      .map((e) => e[1])
                                      .join(","),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 2);
                },
                itemCount: translateResultModelList.translateResultList.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
