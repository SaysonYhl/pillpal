import 'package:flutter/material.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/global_bloc.dart';
import 'package:pillpal/models/medicine.dart';
import 'package:pillpal/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {super.key});
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          2.h,
        ),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            SizedBox(height: 10.h),
            ExtendedSection(medicine: widget.medicine),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kErrorBorderColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  openAlertBox(context, _globalBloc);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kScaffoldColor,
            contentPadding: EdgeInsets.only(
              top: 1.h,
            ),
            title: Text('Delete this Reminder?',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 12.sp,
                      color: kErrorBorderColor,
                    )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: kDarkGrey,
                      ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //global bloc to delete medicine
                  _globalBloc.removeMedicine(widget.medicine);
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: kErrorBorderColor,
                      ),
                ),
              ),
            ],
          );
        });
  }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key, this.medicine});

  final Medicine? medicine;

  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'Bottle') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/icons/bottle.png',
          color: kPrimaryColor,
          height: 10.h,
        ),
      );
    } else if (medicine!.medicineType == 'Pill') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/icons/pill.png',
          color: kPrimaryColor,
          height: 10.h,
        ),
      );
    } else if (medicine!.medicineType == 'Syringe') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/icons/syringe.png',
          color: kPrimaryColor,
          height: 10.h,
        ),
      );
    } else if (medicine!.medicineType == 'Tablet') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Image.asset(
          'assets/icons/tablet.png',
          color: kPrimaryColor,
          height: 10.h,
        ),
      );
    }
    //incase of no med type selected
    else {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Icon(Icons.error, color: kPrimaryColor, size: size),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        makeIcon(10.h,),
        SizedBox(
          width: 2.w,
        ),
        Column(
          children: [
            Hero(
              tag: medicine!.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                    fieldTitle: 'Medicine Name',
                    fieldInfo: medicine!.medicineName!),
              ),
            ),
            SizedBox(height: 0.5.h),
            MainInfoTab(
                fieldTitle: 'Dosage',
                fieldInfo: medicine!.dosage == 0
                    ? 'Not Specified'
                    : '${medicine!.dosage} mg'),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: kDarkGrey,
                    fontSize: 11.sp,
                  ),
            ),
            SizedBox(
              height: 0.2.h,
            ),
            Text(
              fieldInfo,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: kPrimaryColor,
                    fontSize: 15.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({super.key, this.medicine});

  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine!.medicineType! == 'None' ?
          'Not Specified' :
          medicine!.medicineType!,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dosage Interval',
          fieldInfo: 'Every ${medicine!.interval} hours  |  ${medicine!.interval == 24 ? '1 time a day' : '${(24 / medicine!.interval!).floor()} times a day'}',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 1.h,
            ),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: kTextColor,
                  ),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: kHomeColor,
                ),
          ),
        ],
      ),
    );
  }
}
