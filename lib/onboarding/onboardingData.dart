import './onboardingModel.dart';

class OnboardingData {
  List<onboardingModel> items = [
    onboardingModel(
        title: "Income",
        description:
            "Gain control over your finances by managing your income effectively.",
        image: "images/money.png"),
    onboardingModel(
        title: "Expenses",
        description: "Monitor and control your daily expenses with ease.",
        image: "images/salary.png"),
    onboardingModel(
        title: "Financial Planning",
        description:
            "Manage your income and expenses wisely, Plan for a secure financial future.",
        image: "images/budget.png"),
  ];
}
