



class UpDownName{
  final String laneName;

  UpDownName({
    required this.laneName,
  });

  List<String> findName(){
    if(laneName.contains("대구")){
      if(laneName.contains("1호선")) {
        return ["설화명곡", "안심"];
      } else if(laneName.contains("2호선")) {
        return ["문양", "영남대"];
      } else {
        return ["칠곡경대병원","용지"];
      }
    } else {
      if(laneName.contains("1호선")){
        if(!laneName.contains("인천")) {
          return ["소요산 동두천", "인천 천안 동탄"];
        } else{
          return ["계양, 귤현", "동막, 송도달빛축제공원"];
        }
      } else if(laneName.contains("2호선")){
        if(!laneName.contains("인천")) {
          return ["성수", "성수"];
        } else {
          return ["검단오류", "운연"];
        }
      } else if(laneName.contains("3호선")){
        return ["대화", "수서, 오금"];
      } else if(laneName.contains("4호선")){
        return ["당고개, 진접", "오이도, 안산"];
      } else if(laneName.contains("5호선")){
        return ["방화, 화곡", "마천, 하남검단산"];
      } else if(laneName.contains("6호선")){
        return ["응암순환", "봉화산, 신내"];
      } else if(laneName.contains("7호선")){
        return ["도봉산, 장암", "부평구청, 석남"];
      } else if(laneName.contains("8호선")){
        return ["암사", "모란"];
      } else if(laneName.contains("9호선")){
        return ["중앙보훈병원", "개화, 김포공항"];
      } else if(laneName.contains("수인.분당선")){
        return ["왕십리", "인천, 고색"];
      } else if(laneName.contains("김포")){
        return ["양촌, 구래", "김포공항"];
      } else if(laneName.contains("공항")){
        return ["서울역", "검암, 인천공항2터미널"];
      } else if(laneName.contains("경춘")){
        return ["청량리, 광운대, 상봉", "춘천"];
      } else if(laneName.contains("경의중앙")){
        return ["문산, 일산", "용문, 팔당, 덕소"];
      } else if(laneName.contains("1호선")){
        return ["소요산 동두천", "인천 천안 동탄"];
      } else if(laneName.contains("경강선")){
        return ["판교", "부발, 여주"];
      } else if(laneName.contains("신분당선")){
        return ["신사", "광교"];
      }
    }
    return ["미구현", "미구현"];
  }
}