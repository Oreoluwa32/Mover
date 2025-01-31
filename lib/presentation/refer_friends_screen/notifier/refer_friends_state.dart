part of 'refer_friends_notifier.dart';

// Represents the state of the refer friends screen
// ignore for file, class must be immutable
class ReferFriendsState extends Equatable {
  ReferFriendsState({this.referFriendsModelObj, this.codeController});

  ReferFriendsModel? referFriendsModelObj;
  TextEditingController? codeController;


  @override
  List<Object?> get props => [codeController, referFriendsModelObj];
  ReferFriendsState copyWith({TextEditingController? codeController, ReferFriendsModel? referFriendsModelObj}) {
    return ReferFriendsState(
      codeController: codeController ?? this.codeController, 
      referFriendsModelObj: referFriendsModelObj ?? this.referFriendsModelObj);
  }
}