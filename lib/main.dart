import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/firebase_options.dart';
import 'package:pillpal/global_bloc.dart';
import 'package:pillpal/welcome_screens/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static const platform = MethodChannel('com.example.pillpal/exact_alarm');

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc? globalBloc;

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc();
  }


  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'PillPal',
          //theme customization
          theme: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kScaffoldColor,
            //appbar theme
            appBarTheme: AppBarTheme(
              toolbarHeight: 7.h,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: kSecondaryColor,
                size: 20.sp,
              ),
              titleTextStyle: GoogleFonts.mulish(
                color: kTextColor,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                fontSize: 16.sp,
              ),
            ),
            textTheme: TextTheme(
              displaySmall: TextStyle(
                fontSize: 24.sp,
                color: kSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
              headlineMedium: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
              titleSmall: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: kTextColor,
              ),
              titleLarge: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: kScaffoldColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
              labelMedium: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              ),
              bodySmall: GoogleFonts.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: kScaffoldColor,
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kTextLightColor,
                  width: 0.7,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kTextLightColor,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
              ),
            ),
            //timePicker theme
            timePickerTheme: TimePickerThemeData(
              backgroundColor: kScaffoldColor,
              hourMinuteColor: kHomeColor,
              hourMinuteTextColor: kScaffoldColor,
              dayPeriodColor: kHomeColor,
              dayPeriodTextColor: kTextColor,
              dialBackgroundColor: kHomeColor,
              dialHandColor: kScaffoldColor,
              entryModeIconColor: kTextColor,
              dayPeriodTextStyle: GoogleFonts.aBeeZee(
                fontSize: 8.sp,
              ),
            ),
          ),

          home: const SplashScreen(),
        );
      }),
    );
  }
}
