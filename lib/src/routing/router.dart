import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vidhyatri/src/Notes/NotesHomePage.dart';
import 'package:vidhyatri/src/features/onboarding_view.dart';
import 'package:vidhyatri/src/features/courses/ui/courses_view.dart';
import 'package:vidhyatri/src/features/courses/ui/create_courses.dart';
import 'package:vidhyatri/src/student/ui/student_detail_page.dart';
import 'package:vidhyatri/src/teacher/teacher_home_view.dart';
import '../features/attendance/attendace_view.dart';
import '../features/attendance/take_attendance.dart';
import '../features/auth/views/admin_auth_gate.dart';
import '../features/auth/views/choice_login.dart';
import '../features/auth/views/student_auth_gate.dart';
import '../features/auth/views/teacher_auth_gate.dart';
import '../features/bottom_nav_bar.dart';
import '../shared/settings/setting_Args.dart';
import '../shared/settings/settings_view.dart';
import '../student/profile/user_profile.dart';
import '../shared/constants/routes.dart';
import '../student/home/std_home_view.dart';
import '../student/ui/create_student_form.dart';
import '../student/ui/student_list_page.dart';
import '../teacher/user_profile.dart';
import '../utils/pdf/pdf_getter.dart';
import '../utils/pdf/pdf_picker.dart';
part 'router.g.dart';

// This is the router provider that will be used in the main.dart file
// to pass the router to the MaterialApp.router
@riverpod
GoRouter router(RouterRef ref) {
  (context, state) {
    return RouteInformation(
      location: state.location,
    );
  };
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  // final adminNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'admin');
  // final studentNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'student');
  // final teacherNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
  final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  final courseNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'course');
  final attendanceNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'attendance');
  final profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
  final tProfileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: onboardingRoute,
    debugLogDiagnostics: true,
    // Restoring the state of the router when the app is resumed
    restorationScopeId: 'router',

    routes: [
      GoRoute(
        path: onboardingRoute,
        builder: (context, state) => OnBoardingScreen(),
        // builder: (context, state) => StdHomeViewO(),
        name: onboardingRoute,
      ),

      ///--------------------------------------------Auth---------------------------------------------------------///

      GoRoute(
        path: loginChoiceRoute,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginChoicePage(),
        ),
        name: loginChoiceRoute,
      ),

      /// Define routes based on user role
      GoRoute(
        path: adminAuthRoute,
        builder: (context, state) {
          return const AdminAuthGate();
        },
        name: adminAuthRoute,
      ),
      GoRoute(
        path: teacherAuthRoute,
        builder: (context, state) {
          return const TeacherAuthGate();
        },
        name: teacherAuthRoute,
      ),
      GoRoute(
        path: studentAuthRoute,
        builder: (context, state) {
          return const StudentAuthGate();
        },
        name: studentAuthRoute,
      ),

      ///-----------Student--------------------BottomNavBar---------------------------------------------------///

      StatefulShellRoute.indexedStack(
        builder: (context, state, studentNavigationShell) {
          return StudentNavigationBottomBar(
            navigationShell: studentNavigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: studentRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: StdHomeView(),
                ),
                name: studentRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: courseNavigatorKey,
            routes: [
              GoRoute(
                path: courseRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CoursesView(),
                ),
                name: courseRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: attendanceNavigatorKey,
            routes: [
              GoRoute(
                path: attendanceRoute,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: AttendanceViewingScreen(),
                ),
                name: attendanceRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileNavigatorKey,
            routes: [
              GoRoute(
                path: userProfileRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: UserProfile(),
                ),
                name: userProfileRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
        ],
      ),

      ///-----------Teacher--------------------BottomNavBar---------------------------------------------------///

      StatefulShellRoute.indexedStack(
        builder: (context, state, teacherNavigationShell) {
          return TeacherNavigationBottomBar(
            navigationShell: teacherNavigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            // navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: teacherRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TeacherHomeView(),
                ),
                name: teacherRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
          StatefulShellBranch(
            // navigatorKey: courseNavigatorKey,
            routes: [
              GoRoute(
                path: classRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CoursesView(),
                ),
                name: classRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
          StatefulShellBranch(
            // navigatorKey: attendanceNavigatorKey,
            routes: [
              GoRoute(
                path: studentViewRoute,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: StudentListScreen(),
                ),
                name: studentViewRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: tProfileNavigatorKey,
            routes: [
              GoRoute(
                path: teacherProfileRoute,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TeacherUserProfile(),
                ),
                // name: userProfileRoute,
                // Restoring the state of the route when the app is resumed
              ),
            ],
          ),
        ],
      ),

      ///-----------------------------------Misc..--------------------------------------------------------///

      GoRoute(
        path: '/createStudentFormPage',
        name: 'createStudentFormPage',
        builder: (context, state) => const CreateStudentFormPage(),
        // Restoring the state of the route when the app is resumed
      ),
      GoRoute(
        path: '/studentListPage',
        name: 'studentListPage',
        builder: (context, state) => StudentListScreen(),
        // Restoring the state of the route when the app is resumed
      ),
      GoRoute(
        path: '/student-details',
        name: 'student-details',
        builder: (context, state) => const StudentDetailsPage(),
      ),
      GoRoute(
        path: '/createCourses',
        name: 'createCourses',
        builder: (context, state) => const CreateCourses(),
        // Restoring the state of the route when the app is resumed
      ),
      GoRoute(
        path: '/coursesView',
        name: 'coursesView',
        builder: (context, state) => const CoursesView(),
        // Restoring the state of the route when the app is resumed
      ),
      GoRoute(
        path: '/takeAttendance',
        name: 'takeAttendance',
        builder: (context, state) => const AttendanceTakingScreen(),
        // Restoring the state of the route when the app is resumed
      ),

      GoRoute(
        path: '/settings',
        name: '/settings',
        builder: (context, state) {
          final args = state.extra as SettingsViewArguments;
          return SettingsView(
            controller: args.controller,
            themeMode: args.themeMode,
            onThemeModeChanged: args.onThemeModeChanged,
          );
        },
      ),
      GoRoute(
        path: '/noteshomepage',
        name: '/noteshomepage',
        builder: (context, state) => const StudyMaterialPage(),
      ),
      GoRoute(
        path: '/noteshomepagestd',
        name: '/noteshomepagestd',
        builder: (context, state) => const StudyMaterialPage(
          showAddButton: false,
        ),
      ),
      GoRoute(
        path: '/pdf-downloader',
        name: '/pdf-downloader',
        builder: (context, state) => PdfDownloader(),
      ),
      GoRoute(
        path: '/pdf-uploader',
        name: '/pdf-uploader',
        builder: (context, state) => PdfUploader(),
      ),
    ],

    //*if page not found then it will show the page not found from here.
    errorBuilder: (context, state) => Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Page Not Found",
            textScaler: TextScaler.linear(4),
          ),
          MaterialButton(
              onPressed: () => Navigator.of(context).pop,
              child: const Text("Go Home"))
        ],
      )),
    ),
  );
}
