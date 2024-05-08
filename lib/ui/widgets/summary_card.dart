import 'dart:developer';
import 'package:flutter/material.dart';
import '../../data/models/summary_count_model.dart';

class SummaryCard extends StatefulWidget {
  final List<SummaryCountListData> data;
  const SummaryCard({
    super.key,
    required this.data,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  Map<String?,int?> statusCount ={'New':0, 'CANCELLED':0, 'PROGRESS':0, 'COMPLETE':0};

  void summaryCountListData(){
     for(var object in widget.data ){
       if(statusCount.containsKey(object.sId)){
         statusCount[object.sId] = object.sum;
       }
     }
     if(mounted){
       setState(() {});
     }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    summaryCountListData();

  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  Text(
                    "${statusCount['New']}",
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('New'),
                ]),
              )),
        ),
        Expanded(
          child: Card(
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  Text(
                    "${statusCount['CANCELLED']}",
                    style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Cancelled'),
                ]),
              )),
        ),
        Expanded(
          child: Card(
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  Text(
                    "${statusCount['PROGRESS']}",
                    style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Progress'),
                ]),
              )),
        ),
        Expanded(
          child: Card(
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  Text(
                    "${statusCount['COMPLETE']}",
                    style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Completed'),
                ]),
              )),
        ),
      ],
    );
  }
}
