class FakeData {
  FakeData._();

  static String login() {
    return '''{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODYyNTQ3NzQsIlVzZXIiOiJ7XCJVc2VyR3JvdXBDb2RlXCI6XCJOZWJpbVwiLFwiVXNlck5hbWVcIjpcIjMwMDFZXCIsXCJMYW5nQ29kZVwiOlwiVFJcIixcIklzU2VydmVyQWRtaW5cIjpmYWxzZSxcIklzUGFydG5lclVzZXJcIjpmYWxzZSxcIlVzZXJUeXBlXCI6NCxcIkZ1bGxVc2VyTmFtZVwiOlwiTmViaW0zMDAxWVwiLFwiUG9zaXRpb25cIjp7XCJDb21wYW55Q29kZVwiOjEuMCxcIk9mZmljZUNvZGVcIjpcIjMwMDFcIixcIlN0b3JlQ29kZVwiOlwiMzAwMVwiLFwiV2FyZWhvdXNlQ29kZVwiOlwiXCIsXCJFbXBsb3llZUNvZGVcIjpcIlwifSxcIk1hY0lkXCI6XCIyMzJiOTY5ZS04YTFhLTQwYjYtYmJhZi0zOGVkZGEwYjAyOWZcIixcIlBvc1Rlcm1pbmFsXCI6bnVsbCxcIlBhc3N3b3JkXCI6XCIxSmRaYi9Jcng3U3hxbXdPL0UydTFBPT1cIixcIlBvc1Rlcm1pbmFsSWRcIjowfSJ9.kYqAnJkE5P0qgpGYomBm6Xh7a837Uya9MgH_ClYYrJQ",
  "validTo": "2020-04-07T10:19:34Z",
  "resultType": 0
}''';
  }

  static String serviceRoutes() {
    return '''[
  {
    "description": "Kartal - Pendik"
  },

   {
    "description": "Kadıköy - Ümraniye"
  },

   {
    "description": "Samandıra - Kartal"
  },

   {
    "description": "Maltepe - Gayrettepe"
  } 
]''';
  }

  static String deservedRights() {
    return '''[
  {
    "description": "Hak Ediş 1"
  },

  {
    "description": "Hak Ediş 2"
  },

   {
    "description": "Hak Ediş 3"
  },

   {
    "description": "Hak Ediş 4"
  },

   {
    "description": "Hak Ediş 5"
  } 
]''';
  }

  static String serviceDocuments() {
    return '''[
  {
    "description": "Ehliyet"
  },

   {
    "description": "Ruhsat"
  },

   {
    "description": "Trafik Sigortası"
  },

   {
    "description": "Kasko"
  } 
]''';
  }
}
