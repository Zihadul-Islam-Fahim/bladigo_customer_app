import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';

class NewOrderTrackingScreen extends StatefulWidget {
  const NewOrderTrackingScreen({super.key});

  @override
  State<NewOrderTrackingScreen> createState() => _NewOrderTrackingScreenState();
}

class _NewOrderTrackingScreenState extends State<NewOrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color(0xfffefefe),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _filterButtonSection(context),
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) => _orderedItemCard(context),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: 12)
          ],
        ),
      ),
    );
  }

  Card _orderedItemCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _orderIdSection(context),
            _dottedLine(),
            _orderItemsSection(context),
            _dottedLine(),
            _totalPay(context),
            _dottedLine(),
            _cancelAndTrackOrderButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _totalPay(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Pay',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          '\$140.00',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }

  Widget _orderItemsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 4,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CircleAvatar(radius: 4),
            Text(
              '1 x lorem and Sambar',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.5,
                color: Colors.grey[700],
              ),
            )
          ],
        ),
        Icon(
          Icons.arrow_circle_right_sharp,
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }

  Column _dottedLine() {
    return Column(
      children: [
        SizedBox(height: 8),
        DottedLine(),
        SizedBox(height: 8),
      ],
    );
  }

  Row _orderIdSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Order ID: #303',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '18, September 2025 09:21 AM',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        _orderStatusButton(context, 'Confirmed')
      ],
    );
  }

  Widget _orderStatusButton(BuildContext context, String status) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).primaryColor),
          color: Theme.of(context).primaryColor.withOpacity(0.1)),
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
        child: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Row _filterButtonSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              maximumSize: Size(Get.width * 0.45, 32),
              minimumSize: Size(Get.width * 0.45, 32)),
          child: Text('Ongoing'),
        ),
        SizedBox(width: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              maximumSize: Size(Get.width * 0.45, 32),
              minimumSize: Size(Get.width * 0.45, 32)),
          child: Text('History'),
        )
      ],
    );
  }

  Row _cancelAndTrackOrderButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              maximumSize: Size(Get.width * 0.45, 32),
              minimumSize: Size(Get.width * 0.45, 32)),
          child: Text('Cancel'),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              maximumSize: Size(Get.width * 0.45, 32),
              minimumSize: Size(Get.width * 0.45, 32)),
          child: Text('Track Order'),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 12,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomInkWellWidget(
          radius: 12,
          onTap: () => Get.back(),
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey)),
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
      centerTitle: true,
      title: Text('My Order'),
    );
  }
}
