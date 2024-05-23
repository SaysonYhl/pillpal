import 'package:flutter/material.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/global_bloc.dart';
import 'package:pillpal/models/medicine.dart';
import 'package:pillpal/pages/medicine_details/medicine_details.dart';
import 'package:pillpal/pages/new_entry/new_entry_page.dart';
import 'package:pillpal/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const TopContainer(),
            SizedBox(
              height: 2.h,
            ),
            //the widget takes space as needed
            const Flexible(
              child: BottomContainer(),
            ),
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewEntryPage(),
            ),
          );
        },
        child: SizedBox(
          width: 18.w,
          height: 18.h,
          child: Card(
            color: kErrorBorderColor,
            shape: const CircleBorder(),
            child: Icon(
              Icons.add,
              color: kScaffoldColor,
              size: 40.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                bottom: 1.h,
              ),
              child: Text(
                'Stay on track, \nStay healthy.',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                bottom: 1.h,
              ),
              child: Text(
                'Your PillPal.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
        SizedBox(
          width: 20.w,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            highlightColor: Colors.white,
            splashColor: kScaffoldColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, Widget? child) {
                        return Opacity(
                          opacity: animation.value,
                          child: const ProfilePage(),
                        );
                      },
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kScaffoldColor,
                  width: 1,
                ),
              ),
              child: const CircleAvatar(
                backgroundColor: kScaffoldColor,
                radius: 35,
                child: Icon(
                  Icons.account_circle,
                  color: kPrimaryColor,
                  size: 73,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder(
        stream: globalBloc.medicineList$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //if no data is saved
            return Container();
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Meds yet :(',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.only(
                top: 1.h,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MedicineCard(
                  medicine: snapshot.data![index],
                );
              },
            );
          }
        });
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;
  //getting current details of saved items

  Hero makeIcon(double size) {
    if (medicine.medicineType == 'Bottle') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/icons/bottle.png',
          color: Colors.white,
          height: 10.h,
        ),
      );
    } else if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/icons/pill.png',
          color: Colors.white,
          height: 10.h,
        ),
      );
    } else if (medicine.medicineType == 'Syringe') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/icons/syringe.png',
          color: Colors.white,
          height: 10.h,
        ),
      );
    } else if (medicine.medicineType == 'Tablet') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Image.asset(
          'assets/icons/tablet.png',
          color: Colors.white,
          height: 10.h,
        ),
      );
    }
    //incase of no med type selected
    else {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Icon(Icons.error, color: Colors.white, size: size),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        //go to details activity with animation

        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: MedicineDetails(medicine),
                  );
                },
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
          padding: EdgeInsets.only(
            left: 2.h,
            right: 2.w,
            top: 1.h,
            bottom: 1.h,
          ),
          margin: EdgeInsets.all(
            1.h,
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(
              2.h,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              makeIcon(
                10.h,
              ),
              const Spacer(),
              //hero tag animation
              Hero(
                tag: medicine.medicineName!,
                child: Text(
                  medicine.medicineName!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 0.3.h,
              ),
              //time interval data with condition
              Text(
                medicine.interval == 1
                    ? 'Every ${medicine.interval} hour'
                    : 'Every ${medicine.interval} hours',
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Color.fromARGB(255, 202, 202, 202),
                    ),
              ),
            ],
          )),
    );
  }
}
