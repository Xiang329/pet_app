import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/pages/auth/login_page.dart';
import 'package:pet_app/pages/home_container_page.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:provider/provider.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  Future<void> loadPage() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthModel, User?>(
      selector: (context, auth) => auth.user,
      builder: (context, user, child) {
        if (_isLoading) {
          return Scaffold(
            backgroundColor: UiColor.theme2Color,
            body: Image.asset(
              AssetsImages.loadLogoJpg,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          );
        }
        if (user == null) {
          return const LoginPage();
        } else {
          Provider.of<AppProvider>(context, listen: false)
              .setEamil(user.email!);
          return const HomeContainerPage();
        }
      },
    );
  }
}
