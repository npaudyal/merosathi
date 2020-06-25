import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is CountryChanged) {
      yield* _mapCountryChangedToState(event.country);
    }  else if (event is CommunityChanged) {
      yield* _mapCommunityChangedToState(event.community);
    }  else if (event is HeightPChanged) {
      yield* _mapHeightPChangedToState(event.heightP);
    } else if (event is ReligionChanged) {
      yield* _mapReligionChangedToState(event.religion);
    } else if (event is BioChanged) {
      yield* _mapBioChangedToState(event.bio);
    } else if (event is JobChanged) {
      yield* _mapJobChangedToState(event.job);
    } else if (event is GotraChanged) {
      yield* _mapGotraChangedToState(event.gotra);
    } else if (event is SalaryChanged) {
      yield* _mapSalaryChangedToState(event.salary);
    } else if (event is EducationChanged) {
      yield* _mapEducationChangedToState(event.education);
    }
    
     else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
          photo: event.photo,
          name: event.name,
          gender: event.gender,
          userId: uid,
          age: event.age,
          location: event.location,
          interestedIn: event.interestedIn,
          country: event.country,
          community: event.community,
          heightP: event.heightP,
          salary: event.salary,
          religion: event.religion,
          bio: event.bio,
          job: event.job,
          gotra: event.gotra,
          education:event.education
          );
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapAgeChangedToState(DateTime age) async* {
    yield state.update(
      isAgeEmpty: age == null,
    );
  }

  Stream<ProfileState> _mapGenderChangedToState(String gender) async* {
    yield state.update(
      isGenderEmpty: gender == null,
    );
  }

  Stream<ProfileState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    yield state.update(
      isInterestedInEmpty: interestedIn == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }


 Stream<ProfileState> _mapCountryChangedToState(String country) async* {
    yield state.update(
      isCountryEmpty: country == null,
    );
  }

   Stream<ProfileState> _mapCommunityChangedToState(String community) async* {
    yield state.update(
      isCommunityEmpty: community == null,
    );
  }
   Stream<ProfileState> _mapHeightPChangedToState(String heightP) async* {
    yield state.update(
      isHeightPEmpty: heightP == null,
    );
  }
   Stream<ProfileState> _mapBioChangedToState(String bio) async* {
    yield state.update(
      isBioEmpty: bio == null,
    );
  }
   Stream<ProfileState> _mapGotraChangedToState(String gotra) async* {
    yield state.update(
      isGotraEmpty: gotra == null,
    );
  }
   Stream<ProfileState> _mapReligionChangedToState(String religion) async* {
    yield state.update(
      isReligionEmpty: religion == null,
    );
  }
   Stream<ProfileState> _mapSalaryChangedToState(String salary) async* {
    yield state.update(
      isSalaryEmpty: salary == null,
    );
  }
   Stream<ProfileState> _mapJobChangedToState(String job) async* {
    yield state.update(
      isJobEmpty: job == null,
    );
  }

   Stream<ProfileState> _mapEducationChangedToState(String education) async* {
    yield state.update(
      isEducationEmpty: education == null,
    );
  }




  Stream<ProfileState> _mapSubmittedToState(
      {File photo,
      String gender,
      String name,
      String userId,
      DateTime age,
      GeoPoint location,
      String interestedIn,
      String country, 
      String heightP,
      String community,
      String salary,
      String gotra,
      String bio,
      String job,
      String religion,
      String education

      }) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileSetup(
          photo, userId, name, gender, interestedIn,country, heightP, community,salary,gotra,job,bio,religion,education, age, location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}