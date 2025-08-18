import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/di.dart';
import 'features/program/presentation/bloc/program_bloc.dart';
import 'features/program/presentation/bloc/program_event.dart';
import 'features/program/presentation/bloc/session_bloc.dart';
import 'features/program/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notificationsService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProgramBloc>(create: (_) => createProgramBloc()..add(const LoadRequested())),
        BlocProvider<SessionBloc>(create: (_) => createSessionBloc()),
      ],
      child: MaterialApp(
        title: 'Sun Tan App',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange)),
        home: const HomePage(),
      ),
    );
  }
}
 
