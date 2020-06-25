import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class LoadingMState extends MatchesState {}

class LoadUserMState extends MatchesState {
  final Stream<QuerySnapshot> matchedList;
  final Stream<QuerySnapshot> selectedList;

  LoadUserMState({this.matchedList, this.selectedList});

  @override
  List<Object> get props => [matchedList, selectedList];
}
