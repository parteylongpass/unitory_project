import 'package:flutter/material.dart';
import 'package:unitory_project/Item/model/item_model.dart';
import 'package:unitory_project/common/const/colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            thumbUrl != ""
                ? ClipRRect(
                    child: Image.network(
                      thumbUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                : ClipRRect(
                    child: Image.asset(
                      "asset/img/no_img.jpg",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    uploadTimeDiff(uploadTime),
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "${price.toString()}원",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: PRIMARY_COLOR,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        whichType(itemRentalPeriodType),
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String uploadTimeDiff(DateTime uploadTime) {
    Duration diff = DateTime.now().difference(uploadTime);

    if (diff.inDays >= 1) {
      return "${diff.inDays}일 전";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours}시간 전";
    } else {
      return "${diff.inMinutes}분 전";
    }
  }

  String whichType(ItemRentalPeriodType type) {
    if (type == ItemRentalPeriodType.month) {
      return " /월";
    } else if (type == ItemRentalPeriodType.week) {
      return " /주";
    } else {
      return " /일";
    }
  }
}
