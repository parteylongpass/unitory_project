import 'package:flutter/material.dart';
import 'package:unitory_project/Item/model/item_model.dart';

class ItemCard extends StatelessWidget {
  final String thumbUrl;
  final String title;
  final int price;
  final ItemRentalPeriodType itemRentalPeriodType;
  final DateTime uploadTime;

  const ItemCard(
      {super.key,
      required this.thumbUrl,
      required this.title,
      required this.price,
      required this.itemRentalPeriodType,
      required this.uploadTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          child: Image.network(thumbUrl, width: 100, height: 100, fit: BoxFit.cover,),
          borderRadius: BorderRadius.circular(12.0),
        ),
        SizedBox(width: 12.0,),
        Expanded(
          child: Column(
            children: [
              Text(title),
              Text(uploadTimeDiff(uploadTime)),
              SizedBox(height: 12.0,),
              Row(
                children: [
                  Text(price.toString()),
                  Text(whichType(itemRentalPeriodType)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  String uploadTimeDiff(DateTime uploadTime) {
    Duration diff = DateTime.now().difference(uploadTime);

    if(diff.inDays >= 1) {
      return "${diff.inDays}일 전";
    } else if(diff.inHours >= 1) {
      return "${diff.inHours}시간 전";
    } else {
      return "${diff.inMinutes}분 전";
    }
  }

  String whichType(ItemRentalPeriodType type) {
    if(type == "ItemRentalPeriodType.month") {
      return "/월";
    } else if(type == "ItemRentalPeriodType.week") {
      return "/주";
    } else {
      return "/일";
    }
  }
}
