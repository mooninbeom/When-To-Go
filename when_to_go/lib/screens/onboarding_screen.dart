import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:when_to_go/main.dart';






class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      dotsFlex: 3,
      nextFlex: 1,
      dotsContainerDecorator: const BoxDecoration(
        color: Colors.white,
      ),
      doneStyle: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.purple.withOpacity(0.1)),
      ),

      
      dotsDecorator: DotsDecorator(
        color: Colors.purple.withOpacity(0.1),
        activeColor: Colors.purple,
        activeSize: const Size(20,10),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      ),

      controlsPadding: const EdgeInsets.all(20),
      done: SizedBox(child: Text("고고", style: TextStyle(color: Colors.purple.withOpacity(0.6)),)),
      onDone: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          MyApp(),));
      },
      showNextButton: false,
      pages: [
        PageViewModel(

          decoration: decoration,
          title: "지하철 역을 검색하세요!",
          body: "현재 탈려고 하는 지하철 역을 검색해보세요.",
          image: Container(
              
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
              ),
              child: Image.asset("assets/search screen.png" )),


        ),
        PageViewModel(
          title: "원하는 역을 선택하세요!",
          body: "키워드에 맞는 다양한 역이 나옵니다.\n완전 놀라운걸?",
          decoration: decoration,
          image: Container(

              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Image.asset("assets/station list screen.png" )),


        ),
        PageViewModel(
          title: "언제 출발해야 할지 걱정할\n필요 없어요~",
          body: "그거 얘가 다 알려줍니다.\n 언제 출발할지, 가는데 얼마나 걸리는지\n경로는 어떻게 되는지\n걱정 ㄴㄴ",
          decoration: decoration,
          image: Container(

              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Image.asset("assets/result screen.png" )),

        ),
        PageViewModel(
            title: "버스가 언제 오냐구요?\n얘는 알아요~",
            body: "왠만한 버스 다 알아요. 그냥 얘한테 물어보세요",
            decoration: decoration,
            image: Container(

                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Image.asset("assets/bus screen.png" )),


        ),
        PageViewModel(
            title: "당신네 주변의 정류장 자동 검색 wow~",
            body: "검색도 귀찮은 당신에게 가장 중요한 기능",
            decoration: decoration,
            image: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Image.asset("assets/poi search screen.png" )),

        ),
        PageViewModel(
          title: "너무나도 사용하고 싶은\n앱인걸?",
          body: "지금 당장 사용하러 ㄱㄱ\n 아니면 유감😂",
          decoration: PageDecoration(
            bodyAlignment: Alignment.center,
              pageColor: Colors.purple.withOpacity(0.3),
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400
              )
          ),

        ),
      ],
    );
  }

  PageDecoration decoration = PageDecoration(
      imageFlex: 2,
      bodyFlex: 1,
      imagePadding: const EdgeInsets.symmetric(horizontal: 50,),
      imageAlignment: Alignment.bottomCenter,
      pageColor: Colors.purple.withOpacity(0.3),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400
      )
  );
}
