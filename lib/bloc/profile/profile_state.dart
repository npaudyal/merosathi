import 'package:meta/meta.dart';

@immutable
class ProfileState {
  final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isGenderEmpty;
  final bool isInterestedInEmpty;
  final bool isLocationEmpty;
  final bool isCountryEmpty;
  final bool isCommunityEmpty;
  final bool isHeightPEmpty;
  final bool isJobEmpty;
  final bool isGotraEmpty;
  final bool isReligionEmpty;
  final bool isBioEmpty;
  final bool isSalaryEmpty;
  final bool isEducationEmpty;
  final bool isInstaEmpty;
  final bool isLiveEmpty;



  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;


  bool get isFormValid =>
      isPhotoEmpty &&
      isNameEmpty &&
      isAgeEmpty &&
      isGenderEmpty &&
      isInterestedInEmpty;

  ProfileState({
    @required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isAgeEmpty,
    @required this.isGenderEmpty,
    @required this.isInterestedInEmpty,
    @required this.isLocationEmpty,

    @required this.isCountryEmpty,
    @required this.isCommunityEmpty,
    @required this.isBioEmpty,
    @required this.isGotraEmpty,
    @required this.isHeightPEmpty,
    @required this.isJobEmpty,
    @required this.isReligionEmpty,
    @required this.isSalaryEmpty,
    @required this.isEducationEmpty,
    @required this.isInstaEmpty,
    @required this.isLiveEmpty,


    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory ProfileState.empty() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isCommunityEmpty: false,
      isCountryEmpty: false,
      isGotraEmpty: false,
      isHeightPEmpty: false,
      isJobEmpty: false,
      isReligionEmpty: false,
      isSalaryEmpty: false,
      isEducationEmpty: false,
      isInstaEmpty: false,
      isLiveEmpty: false,
      
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isCommunityEmpty: false,
      isCountryEmpty: false,
      isGotraEmpty: false,
      isHeightPEmpty: false,
      isJobEmpty: false,
      isReligionEmpty: false,
      isSalaryEmpty: false,
      isEducationEmpty: false,
      isInstaEmpty: false,
      isLiveEmpty: false,
    );
  }

  factory ProfileState.failure() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: true,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isCommunityEmpty: false,
      isCountryEmpty: false,
      isGotraEmpty: false,
      isHeightPEmpty: false,
      isJobEmpty: false,
      isReligionEmpty: false,
      isSalaryEmpty: false,
      isEducationEmpty: false,
      isInstaEmpty: false,
      isLiveEmpty: false,
    );
  }

  factory ProfileState.success() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: true,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isCommunityEmpty: false,
      isCountryEmpty: false,
      isGotraEmpty: false,
      isHeightPEmpty: false,
      isJobEmpty: false,
      isReligionEmpty: false,
      isSalaryEmpty: false,
      isEducationEmpty: false,
      isInstaEmpty: false,
      isLiveEmpty: false,
    );
  }

  ProfileState update({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedInEmpty,
    bool isLocationEmpty,
    bool  isBioEmpty,
    bool isCommunityEmpty,
   bool   isCountryEmpty,
    bool  isGotraEmpty,
   bool   isHeightPEmpty,
   bool   isJobEmpty,
   bool   isReligionEmpty,
   bool   isSalaryEmpty,
   bool isEducationEmpty,
   bool isInstaEmpty,
   bool isLiveEmpty,
  }) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isPhotoEmpty: isPhotoEmpty,
      isNameEmpty: isNameEmpty,
      isAgeEmpty: isAgeEmpty,
      isGenderEmpty: isGenderEmpty,
      isInterestedInEmpty: isInterestedInEmpty,
      isLocationEmpty: isLocationEmpty,

      isCommunityEmpty: isCommunityEmpty,
      isCountryEmpty: isCountryEmpty,
      isJobEmpty : isJobEmpty,
      isReligionEmpty: isReligionEmpty,
      isBioEmpty: isBioEmpty,
      isSalaryEmpty: isSalaryEmpty,
      isGotraEmpty: isGotraEmpty,
      isHeightPEmpty: isHeightPEmpty,
      isEducationEmpty: isEducationEmpty,
      isInstaEmpty: isInstaEmpty,
      isLiveEmpty : isLiveEmpty,



    );
  }

  ProfileState copyWith({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedInEmpty,
    bool isLocationEmpty,
    bool  isBioEmpty,
    bool isCommunityEmpty,
   bool   isCountryEmpty,
    bool  isGotraEmpty,
   bool   isHeightPEmpty,
   bool   isJobEmpty,
   bool   isReligionEmpty,
   bool   isSalaryEmpty,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isEducationEmpty,
    bool isInstaEmpty,
    bool isLiveEmpty,
  }) {
    return ProfileState(
      isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isInterestedInEmpty: isInterestedInEmpty ?? this.isInterestedInEmpty,
      isGenderEmpty: isGenderEmpty ?? this.isGenderEmpty,
      isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,

      isCommunityEmpty: isCommunityEmpty ?? this.isCommunityEmpty,
      isCountryEmpty: isCountryEmpty ?? this.isCountryEmpty,
      isJobEmpty : isJobEmpty ?? this.isJobEmpty,
      isReligionEmpty: isReligionEmpty ?? this.isReligionEmpty,
      isBioEmpty: isBioEmpty ?? this.isBioEmpty,
      isSalaryEmpty: isSalaryEmpty?? this.isSalaryEmpty,
      isGotraEmpty: isGotraEmpty ?? this.isGotraEmpty,
      isHeightPEmpty: isHeightPEmpty ?? this.isHeightPEmpty,
      isEducationEmpty: isEducationEmpty ?? this.isEducationEmpty,
      isInstaEmpty: isInstaEmpty ?? this.isInstaEmpty,
      isLiveEmpty: isLiveEmpty ?? this.isLiveEmpty,


      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
