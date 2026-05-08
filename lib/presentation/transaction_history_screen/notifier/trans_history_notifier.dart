import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/wallet_model.dart';
import '../../../data/services/wallet_api_service.dart';
import '../models/balance_item_model.dart';
import '../models/month_trans_item_model.dart';
import '../models/transaction_history_model.dart';
import '../models/transaction_item_model.dart';

part 'trans_history_state.dart';

final transHistoryNotifier =
    StateNotifierProvider.autoDispose<TransHistoryNotifier, TransHistoryState>(
  (ref) {
    final walletApiService = ref.watch(walletApiServiceProvider);
    return TransHistoryNotifier(
      TransHistoryState(
        sliderIndex: 0,
        transactionHistoryModelObj: TransactionHistoryModel(
          balanceList: [
            BalanceItemModel(
              title: "Balance",
              icon: ImageConstant.imgEye,
              balance: "₦ 0.00",
            ),
            BalanceItemModel(
              title: "Available Balance",
              icon: ImageConstant.imgEye,
              balance: "₦ 0.00",
            ),
          ],
          monthTransList: const [],
          transactionList: const [],
        ),
      ),
      walletApiService,
    )
      ..fetchWalletData()
      ..fetchFundingAccount();
  },
);

class TransHistoryNotifier extends StateNotifier<TransHistoryState> {
  TransHistoryNotifier(TransHistoryState state, this._walletApiService)
      : super(state);

  final WalletApiService _walletApiService;

  void changeSliderIndex(int index) {
    state = state.copyWith(sliderIndex: index);
  }

  void toggleBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
  }

  Future<void> fetchWalletData() async {
    state = state.copyWith(isLoading: true);
    try {
      final walletData = await _walletApiService.fetchWalletData();
      final currency = walletData.currency ?? "₦";

      final balanceList = [
        BalanceItemModel(
          title: "Balance",
          icon: ImageConstant.imgEye,
          balance: CurrencyFormatter.formatAmount(
            walletData.balance,
            currency: currency,
          ),
        ),
        BalanceItemModel(
          title: "Available Balance",
          icon: ImageConstant.imgEye,
          balance: CurrencyFormatter.formatAmount(
            walletData.availableBalance,
            currency: currency,
          ),
        ),
      ];

      final transactionList = walletData.transactions?.map((transaction) {
            final amount = double.tryParse(transaction.amount ?? "0") ?? 0;
            final formattedAmount = CurrencyFormatter.formatSignedAmount(
              amount,
              currency: currency,
            );
            return TransactionItemModel(
              id: transaction.id,
              transStatus: transaction.type,
              transDate: transaction.date,
              transTime: transaction.time,
              amount: formattedAmount,
              status: transaction.status,
            );
          }).toList() ??
          const [];

      final monthTransList = walletData.transactions?.map((transaction) {
            final amount = double.tryParse(transaction.amount ?? "0") ?? 0;
            final formattedAmount = CurrencyFormatter.formatSignedAmount(
              amount,
              currency: currency,
            );
            return MonthTransItemModel(
              transStatus: transaction.type,
              transDate: transaction.date,
              transTime: transaction.time,
              amount: formattedAmount,
              status: transaction.status,
            );
          }).toList() ??
          const [];

      state = state.copyWith(
        isLoading: false,
        fundingAccount: walletData.fundingAccount ?? state.fundingAccount,
        transactionHistoryModelObj: state.transactionHistoryModelObj?.copyWith(
          balanceList: balanceList,
          transactionList: transactionList,
          monthTransList: monthTransList,
        ),
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchFundingAccount() async {
    state = state.copyWith(
      fundingAccountLoading: true,
      fundingAccountError: null,
    );
    try {
      final fundingAccount = await _walletApiService.fetchFundingAccount();
      state = state.copyWith(
        fundingAccountLoading: false,
        fundingAccount: fundingAccount,
        fundingAccountError: null,
      );
    } catch (error) {
      state = state.copyWith(
        fundingAccountLoading: false,
        fundingAccountError: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<WalletFundingAccount> provisionFundingAccount() async {
    state = state.copyWith(
      fundingAccountLoading: true,
      fundingAccountError: null,
    );
    try {
      final fundingAccount = await _walletApiService.provisionFundingAccount();
      state = state.copyWith(
        fundingAccountLoading: false,
        fundingAccount: fundingAccount,
        fundingAccountError: null,
      );
      return fundingAccount;
    } catch (error) {
      final message = error.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        fundingAccountLoading: false,
        fundingAccountError: message,
      );
      rethrow;
    }
  }
}
