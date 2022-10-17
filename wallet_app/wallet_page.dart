import 'package:flutter/material.dart';
import 'package:starcoin/api.dart';
import 'package:starcoin/bloc/wallet_bloc.dart';
import 'package:starcoin/views/search_result_view.dart';
import 'package:starcoin/widgets/bottom_navigation_bar.dart';
import 'package:starcoin/widgets/ads_container.dart';
import 'package:starcoin/widgets/app_custom_bar.dart';
import 'package:starcoin/widgets/app_spaces.dart';
import 'package:starcoin/views/wallet/widgets/wallet_list.dart';
import 'package:starcoin/utyls/helpers.dart';


class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late final WalletBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WalletBloc(api: Api());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomBar(
        title: const Text('common_wallet'.t),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpaces.xsm),
        child: Column(
          children: [
            AdsContainer(),
            AppSizeBox(height: AppSpaces.md),
            Text('common_my_wallets'.t, style: AppTextStyle.head2),
            AppSizeBox(height: AppSpaces.sm),
            WalletList()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(),
    );
  }
}
