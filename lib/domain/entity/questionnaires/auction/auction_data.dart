
import 'package:uuid/uuid.dart';

class Auction {
  String? auctionId;
  String? name;
  String? question;
  double? response;

  Auction({this.auctionId, this.name, this.question, this.response});
}

class AuctionNotificationDto {
  String? auctionId;
  String? title;
  String? description;
  String? buyer;
  String? createdAt;
  String? sleepDuration;
  String? qualityOfSleep;
  String? painIntensity;
  String? numberOfWakeupTimes;

  AuctionNotificationDto({
    this.auctionId,
    this.title,
    this.description,
    this.buyer,
    this.createdAt,
    this.sleepDuration,
    this.qualityOfSleep,
    this.painIntensity,
    this.numberOfWakeupTimes,
  });

  factory AuctionNotificationDto.fromJson(Map<String, dynamic> json) {
    return AuctionNotificationDto(
      auctionId: json['auctionId'],
      title: json['title'],
      description: json['description'],
      buyer: json['buyer'],
      createdAt: json['createdAt'],
      sleepDuration: json['sleepDuration'],
      qualityOfSleep: json['qualityOfSleep'],
      painIntensity: json['painIntensity'],
      numberOfWakeupTimes: json['numberOfWakeupTimes'],
    );
  }
}
class Winnings {
  double? totalWinnings;
  List<AuctionWinnings>? data;

  Winnings({
    this.totalWinnings,
    this.data
  });

  Winnings.fromJson(Map<String, dynamic> json) {
    totalWinnings = json['totalWinnings'];
    if (json['data'] != null) {
      data = <AuctionWinnings>[];
      json['data'].forEach((v) {
        data!.add(new AuctionWinnings.fromJson(v));
      });
    }
    // return Winnings(
    //   totalWinnings: json['totalWinnings'],
    //
    //   data: [AuctionWinnings.fromJson(json['data'])],
    // );
  }
}

class AuctionWinnings {
  String? id;
  String? auctionId;
  String? auctionDataType;
  String? winnerId;
  double? winningValue;
  double? biddingValue;
  String? createdAt;

  AuctionWinnings({
    this.id,
    this.auctionId,
    this.auctionDataType,
    this.winnerId,
    this.winningValue,
    this.biddingValue,
    this.createdAt
  });

  factory AuctionWinnings.fromJson(Map<String, dynamic> json) {
    return AuctionWinnings(
      id: json["id"],
      auctionId: json['auctionId'],
      auctionDataType: json["auctionDataType"],
      winnerId: json["winnerId"],
      winningValue: json["winningValue"],
      biddingValue: json["biddingValue"],
      createdAt: json["createdAt"]
    );
  }
}

class AuctionResponse {
  String? userId;
  String? auctionId;
  double? sleepDurationData;
  double? painIntensityData;
  double? sleepQualityData;
  double? numberOfWakeupTimes;

  AuctionResponse({
    this.userId,
    this.auctionId,
    this.sleepDurationData,
    this.painIntensityData,
    this.sleepQualityData,
    this.numberOfWakeupTimes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['auctionId'] = this.auctionId;
    data['sleepDurationData'] = this.sleepDurationData;
    data['painIntensityData'] = this.painIntensityData;
    data['sleepQualityData'] = this.sleepQualityData;
    data['numberOfWakeupTimes'] = this.numberOfWakeupTimes;
    return data;
  }
}

class AuctionData {

  int _auctionItemNumber = 0;

  List<Auction> _auctionList = [];

  dynamic nextItem(){
    if (_auctionItemNumber <= _auctionList.length - 1) {
      if (_auctionItemNumber != _auctionList.length - 1) {
        _auctionItemNumber++;
      }
    }
  }

  dynamic previousItem() {
    if (_auctionItemNumber > 0) {
      _auctionItemNumber--;
    }
    return false;
  }

  int itemPosition() {
    return _auctionItemNumber;
  }

  bool lastItem() {
    return _auctionItemNumber == _auctionList.length - 1;
  }

  Auction getItem(){
    return _auctionList[_auctionItemNumber];
  }

  int getItemListLength() {
    return _auctionList.length;
  }

  List<Auction> getItems() {
    return _auctionList;
  }

  void addItemToList(Auction auction) {
    if (auction.name != "auctionId") {
      _auctionList.add(auction);
    }
  }

  void addList(List<Auction> list) {
      _auctionList.addAll(list);
  }

  int startOver(){
    return _auctionItemNumber = 0;
  }


}