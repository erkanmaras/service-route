class FakeData {
  FakeData._();

  static String login() {
    return '''{
    "token": "D568023E9D88FFEF4D40A80118B1744F620C71D1"
}''';
  }

  static String transfer() {
    return '''[
    {
        "id": 1203,
        "completed": true,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-01T00:00:00"
    },
    {
        "id": 1204,
        "completed": true,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-02T00:00:00"
    },
    {
        "id": 1205,
        "completed": true,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-03T00:00:00"
    },
    {
        "id": 1206,
        "completed": true,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-04T00:00:00"
    },
    {
        "id": 1207,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-05T00:00:00"
    },
    {
        "id": 1208,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-06T00:00:00"
    },
    {
        "id": 1209,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-07T00:00:00"
    },
    {
        "id": 1210,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-08T00:00:00"
    },
    {
        "id": 1211,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-01T00:00:00"
    },
    {
        "id": 1212,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-02T00:00:00"
    },
    {
        "id": 1213,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-03T00:00:00"
    },
    {
        "id": 1214,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-04T00:00:00"
    },
    {
        "id": 1215,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-05T00:00:00"
    },
    {
        "id": 1216,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-06T00:00:00"
    },
    {
        "id": 1217,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-07T00:00:00"
    },
    {
        "id": 1218,
        "completed": false,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-08T00:00:00"
    },
    {
        "id": 1219,
        "completed": false,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-01T00:00:00"
    },
    {
        "id": 1220,
        "completed": false,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-02T00:00:00"
    }
]''';
  }

  static String monthlyTransfer() {
    return '''[
    {
        "id": 1206,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-04T00:00:00"
    },
    {
        "id": 1207,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-05T00:00:00"
    },
    {
        "id": 1208,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-06T00:00:00"
    },
    {
        "id": 1209,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-07T00:00:00"
    },
    {
        "id": 1210,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-08T00:00:00"
    },
    {
        "id": 1211,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-01T00:00:00"
    },
    {
        "id": 1212,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-02T00:00:00"
    },
    {
        "id": 1213,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-03T00:00:00"
    },
    {
        "id": 1214,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-04T00:00:00"
    },
    {
        "id": 1215,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-05T00:00:00"
    },
    {
        "id": 1216,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-06T00:00:00"
    },
    {
        "id": 1217,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-07T00:00:00"
    },
    {
        "id": 1218,
        "lineDescription": "DENEME",
        "accountDescription": "TÜRKİYE EKONOMİ BANKASI A.Ş.",
        "transferDate": "2019-05-08T00:00:00"
    },
    {
        "id": 1219,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-01T00:00:00"
    },
    {
        "id": 1220,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-02T00:00:00"
    },
    {
        "id": 1221,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-03T00:00:00"
    },
    {
        "id": 1222,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-04T00:00:00"
    },
    {
        "id": 1223,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-05T00:00:00"
    },
    {
        "id": 1224,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-06T00:00:00"
    },
    {
        "id": 1225,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-07T00:00:00"
    },
    {
        "id": 1226,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-08T00:00:00"
    },
    {
        "id": 1227,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-01T00:00:00"
    },
    {
        "id": 1228,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-02T00:00:00"
    },
    {
        "id": 1229,
        "lineDescription": "KURTKÖY",
        "accountDescription": "AYDIN BORU END. A.Ş.",
        "transferDate": "2019-05-03T00:00:00"
    }
]''';
  }

  static String config() {
    return '''{
    "mapPointCheckRateInSeconds": 10
}''';
  }

  static String uploadTransferFile() {
    return 'filePath';
  }

  static String uploadFile() {
    return 'filePath';
  }

  static String documents() {
    return '';
  }
}
